//
//  HomeVC.swift
//  TouchIDAuth
//
//  Created by vamsi krishna reddy kamjula on 10/21/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftKeychainWrapper

class HomeVC: UIViewController {

    var error:NSError?
    var userName: String!
    var buttonTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "UsernameKey")
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func enableTouchIDBtnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Enable Touch ID" {
            self.buttonTitle = sender.titleLabel?.text
            self.handleTouchIDAuth()
            sender.setTitle("Touch ID Enabled", for: .normal)
            NotificationCenter.default.post(name: TOUCH_ID_ENABLED, object: nil)
        } else {
            self.buttonTitle = sender.titleLabel?.text
            self.handleTouchIDAuth()
            sender.setTitle("Enable Touch ID", for: .normal)
            NotificationCenter.default.post(name: TOUCH_ID_DISABLED, object: nil)
        }
    }
    
    func handleTouchIDAuth() {
        let touchIDContext = LAContext()
        guard touchIDContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            touchOptionAvailableOrNotAlert()
            return
        }
        touchIDContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need Touch ID for 'TouchIDAuth' App") { (success, error) in
            if success {
                if self.buttonTitle == "Enable Touch ID" {
                    KeychainWrapper.standard.set(self.userName, forKey: "UsernameKey")
                } else {
                    KeychainWrapper.standard.removeObject(forKey: "UsernameKey")
                }
            } else {
                self.showCustomErrorMessageAlert(error: error as! LAError)
            }
        }
    }
    
    func touchOptionAvailableOrNotAlert() {
        let alert = UIAlertController.init(title: "No Touch ID Option", message: "Buy a New Upgraded iPhone", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCustomErrorMessageAlert(error: LAError) {
        switch error {
        case LAError.authenticationFailed:
            self.touchIDErrorAlert()
        default:
            self.touchIDErrorAlert()
        }
    }
    
    func touchIDErrorAlert() {
        let alert = UIAlertController.init(title: "Try Again", message: "Something Went Wrong", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
    
}
