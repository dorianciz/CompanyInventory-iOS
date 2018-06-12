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
    var ciUserBrain: CIUserBrain!
    
    
    private var firstLayoutSubviews: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        
        usernameTextfield.text = "t@t.com"
        passwordTextfield.text = "Test123"
        
        ciUserBrain = CIUserBrain()
        
        applyStyles()
        fillStaticLabels()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstLayoutSubviews = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let shouldStaySignedIn = PersistanceService.sharedInstance.shouldStaySignedIn() {
            if shouldStaySignedIn {
                checkIfUserHasBeenLoggedIn()
            }
        }
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
        view.backgroundColor = ThemeManager.sharedInstance.brandColor
        launchScreen.backgroundColor = ThemeManager.sharedInstance.brandColor
        errorLabel.isHidden = true
        usernameTextfield.keyboardType = .emailAddress
        passwordTextfield.isSecureTextEntry = true
        ThemeManager.sharedInstance.styleClearButton(button: loginButton)
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
                        NavigationManager.sharedInstance.showLoader {
                            self.ciUserBrain.fetchCurrentUserProfile(withCompletion: { (ciUser, response) in
                                switch response {
                                case .success:
                                    PersistanceService.sharedInstance.setStaySignedIn(true)
                                    self.performSegue(withIdentifier: Constants.kShowLoggedInAppSegue, sender: nil)
                                case .noInternetConnection:
                                    PopupManager.sharedInstance.showNoInternetConnection {
                                        self.perform(#selector(self.loginAction(_:)))
                                    }
                                case .error:
                                    PopupManager.sharedInstance.showGeneralError()
                                default:
                                    break
                                }
                            })
                        }
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
                        PopupManager.sharedInstance.showNoInternetConnection {
                            self.perform(#selector(self.loginAction(_:)))
                        }
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
