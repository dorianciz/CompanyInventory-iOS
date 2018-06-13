//
//  ProfileViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/7/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import MessageUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLineView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageViewContainer: GradientView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var shareContacButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var noProfileView: UIView!
    @IBOutlet weak var noProfileLabel: UILabel!
    @IBOutlet weak var noProfileButton: UIButton!
    @IBOutlet weak var noProfileDescriptionLabel: UILabel!
    
    private var ciUserData: CIUser?
    private var ciUserBrain: CIUserBrain!
    private var documentManager: DocumentManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ciUserBrain = CIUserBrain()
        documentManager = DocumentManager()
        
        applyStyle()
        fillStaticData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
        fillPersistanceData()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func applyStyle() {
        view.layoutIfNeeded()
        profileImage.layoutIfNeeded()
        profileImage.layer.cornerRadius = profileImage.layer.frame.size.width / 2;
        profileImage.layer.masksToBounds = true;
        nameLineView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        imageViewContainer.topColor = ThemeManager.sharedInstance.generalBlueColor
        imageViewContainer.bottomColor = ThemeManager.sharedInstance.brandColor
        imageViewContainer.shadowColor = ThemeManager.sharedInstance.gradientShadowColor
        ThemeManager.sharedInstance.styleDefaultLabel(usernameLabel)
        ThemeManager.sharedInstance.styleDefaultLabel(phoneNumberLabel)
        ThemeManager.sharedInstance.styleHeaderLabel(nameLabel)
        ThemeManager.sharedInstance.styleClearButton(button: shareContacButton)
        ThemeManager.sharedInstance.styleHeaderLabel(noProfileLabel)
        ThemeManager.sharedInstance.styleDefaultButton(button: noProfileButton)
        ThemeManager.sharedInstance.styleDefaultLabel(noProfileDescriptionLabel)
    }
    
    private func fillStaticData() {
        shareContacButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kShareContact, comment: ""), for: .normal)
        noProfileButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kConfigureProfileButton, comment: ""), for: .normal)
        noProfileLabel.text = NSLocalizedString(Constants.LocalizationKeys.kConfigureProfileTitle, comment: "")
        noProfileDescriptionLabel.text = NSLocalizedString(Constants.LocalizationKeys.kConfigureProfileDescription, comment: "")
    }
    
    private func getUserData() {
        self.ciUserData = ciUserBrain.getCurrentUser()
    }
    
    private func fillPersistanceData() {
        if let ciUserData = ciUserData {
            if let isProfileConfigured = ciUserData.isProfileConfigured.value, isProfileConfigured {
                noProfileView.isHidden = true
                profileImage.image = documentManager.getImageFromDocument(withName: ciUserData.photoPath!)
                nameLabel.text = ciUserData.name
                phoneNumberLabel.text = ciUserData.phoneNumber
                usernameLabel.text = ciUserData.username
                return
            }
        }
        
        noProfileView.isHidden = false
        view.bringSubview(toFront: noProfileView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.kEditProfileSegue {
            if let destinationViewController = segue.destination as? EditProfileViewController {
                destinationViewController.ciUserToChange = ciUserData
            }
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.kEditProfileSegue, sender: sender)
    }
    
    @IBAction func shareContactAction(_ sender: Any) {
        guard let email = ciUserData?.username, let phone = ciUserData?.phoneNumber else {
            return
        }
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Share contact")
            mail.setMessageBody("<p>Dear client,<br><br>For all additional informations, contact me via email to address: \(email)<br><br>Also you can contact me on phone: \(phone)</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    @IBAction func noProfileAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.kEditProfileSegue, sender: sender)
    }
}

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
