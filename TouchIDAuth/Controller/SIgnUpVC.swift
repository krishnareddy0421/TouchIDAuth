//
//  SIgnUpVC.swift
//  TouchIDAuth
//
//  Created by vamsi krishna reddy kamjula on 10/22/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SIgnUpVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tagpGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleKeyboard))
        view.addGestureRecognizer(tagpGesture)
    }

    @objc func handleKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        guard let username = usernameTxt.text, let password = passwordTxt.text, usernameTxt.text != "", passwordTxt.text != "", confirmPasswordTxt.text != "", passwordTxt.text == confirmPasswordTxt.text else {
            self.handleUserCredentialsAlert()
            return
        }
        KeychainWrapper.standard.set(username, forKey: password)
        performSegue(withIdentifier: "toHomeFromSignup", sender: nil)
    }
    
    func handleUserCredentialsAlert() {
        let alert = UIAlertController.init(title: "Something Went Wrong", message: "Try Again", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeFromSignup" {
            let homeVC = segue.destination as! HomeVC
            homeVC.userName = usernameTxt.text
        }
    }
}
