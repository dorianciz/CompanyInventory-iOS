//
//  LoginViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 3/22/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginFieldsContainer: UIView!
    @IBOutlet weak var smallTitle: UILabel!
    @IBOutlet weak var largeTitle: UILabel!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var launchScreen: UIView!
    
    @IBOutlet weak var logoPreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoPreYConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoPreXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoPostLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoPostTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoPostTrailingConstraint: NSLayoutConstraint!
    
    var loginBrain = LoginBrain()
    
    private var firstLayoutSubviews: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        
        usernameTextfield.text = "t@t.com"
        passwordTextfield.text = "Test123"
        applyStyles()
        fillStaticLabels()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstLayoutSubviews = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserHasBeenLoggedIn()
        animateLaunchScreen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let doFirstLayout = firstLayoutSubviews {
            if !doFirstLayout {
                applyStylesAfterSettingsFrames()
                firstLayoutSubviews = true
            }
        }
    }
    
    private func animateLaunchScreen() {
        AnimationChainingFactory.sharedInstance.animation(withDuration: 1.5, withDelay: 0, withAnimations: {
            self.logoPreXConstraint.isActive = false
            self.logoPreYConstraint.isActive = false
            self.logoPreWidthConstraint.isActive = false
            self.logoPostTopConstraint.isActive = true
            self.logoPostLeadingConstraint.isActive = true
            self.logoPostTrailingConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, withCompletion: {
            
        }, withOptions: UIViewAnimationOptions(rawValue: 0)).animation(withDuration: 1, withDelay: 0, withAnimations: {
            self.launchScreen.alpha = 0
        }, withCompletion: {
            self.launchScreen.isHidden = true
        }, withOptions: .showHideTransitionViews).run()
    }
    
    private func applyStyles() {
        errorLabel.isHidden = true
        usernameTextfield.keyboardType = .emailAddress
        passwordTextfield.isSecureTextEntry = true
    }
    
    private func fillStaticLabels() {
        smallTitle.text = NSLocalizedString(Constants.LocalizationKeys.kLoginSmallLabel, comment: "")
        largeTitle.text = NSLocalizedString(Constants.LocalizationKeys.kLoginLargeLabel, comment: "")
        usernameTextfield.placeholder = NSLocalizedString(Constants.LocalizationKeys.kLoginUsernamePlaceholder, comment: "")
        passwordTextfield.placeholder = NSLocalizedString(Constants.LocalizationKeys.kLoginPasswordPlaceholder, comment: "")
        loginButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kLoginButtonTitle, comment: ""), for: .normal)
        errorLabel.text = NSLocalizedString(Constants.LocalizationKeys.kLoginError, comment: "")
    }
    
    private func applyStylesAfterSettingsFrames() {
        ThemeManager.sharedInstance.addShadow(toView: loginFieldsContainer)
    }
    
    private func checkIfUserHasBeenLoggedIn() {
        if loginBrain.checkIfUserIsAlreadyLoggedIn() {
            self.performSegue(withIdentifier: Constants.kShowLoggedInAppSegue, sender: nil)
        }
    }

    @IBAction func loginAction(_ sender: Any) {
        NavigationManager.sharedInstance.showLoader {
            self.loginBrain.login(withUsername: self.usernameTextfield.text, withPassword: self.passwordTextfield.text, withCompletion: { response in
                NavigationManager.sharedInstance.hideLoader {
                    switch response {
                    case .success:
                        self.performSegue(withIdentifier: Constants.kShowLoggedInAppSegue, sender: nil)
                    case .error:
                        self.errorLabel.isHidden = false
                    case .missingUsernameAndPassword:
                        self.usernameTextfield.shake()
                        self.passwordTextfield.shake()
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    case .missingUsername:
                        self.usernameTextfield.shake()
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    case .missingPassword:
                        self.passwordTextfield.shake()
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    case .noInternetConnection:
                        PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kNoInternetConnection, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kRetryButtonTitle, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), withPopupType: .error, withOkCompletion: {
                            self.perform(#selector(self.loginAction(_:)))
                        }, withCancelCompletion: nil)
                    default: break
                    }
                }
            })
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        return true
    }
}
