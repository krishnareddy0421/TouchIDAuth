//
//  ViewController.swift
//  TouchIDAuth
//
//  Created by vamsi krishna reddy kamjula on 10/21/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

class LoginVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        let usernameString = KeychainWrapper.standard.string(forKey: "UsernameKey")
        if usernameString != nil {
            self.handleTouchIDAuth()
        }
        let tagpGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleKeyboard))
        view.addGestureRecognizer(tagpGesture)
    }
    
    @objc func handleKeyboard() {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        usernameTxt.text = ""
        passwordTxt.text = ""
    }

    func handleTouchIDAuth() {
        let touchIDContext = LAContext()
        guard touchIDContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            touchOptionAvailableOrNotAlert()
            return
        }
        touchIDContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need Touch ID for 'TouchIDAuth' App") { (success, error) in
            if success {
                self.performSegue(withIdentifier: "toHome", sender: nil)
            } else {
                self.showCustomErrorMessageAlert(error: error as! LAError)
            }
        }
    }
    
    func showCustomErrorMessageAlert(error: LAError) {
        switch error {
        case LAError.authenticationFailed:
            self.touchIDErrorAlert()
        default:
            self.touchIDErrorAlert()
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let username = usernameTxt.text, let password = passwordTxt.text, usernameTxt.text != "", passwordTxt.text != "" else {
            self.loginFailedAlert()
            return
        }
        if (username == KeychainWrapper.standard.string(forKey: password)) {
            self.performSegue(withIdentifier: "toHome", sender: nil)
        } else {
            self.loginFailedAlert()
        }
    }
    
    func loginFailedAlert() {
        let alert = UIAlertController.init(title: "Username/Password do not match", message: "Try Again", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignup", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            let homeVC = segue.destination as! HomeVC
            homeVC.userName = usernameTxt.text
        }
    }
}

