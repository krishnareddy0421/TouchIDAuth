//
//  ViewController.swift
//  TouchIDAuth
//
//  Created by vamsi krishna reddy kamjula on 10/21/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let username = usernameTxt.text, usernameTxt.text != "" else {
            loginFailedAlert()
            return
        }
    }
    
    func loginFailedAlert() {
        let alert = UIAlertController.init(title: "Username/Password do not match", message: "Try Again", preferredStyle: .alert)
        let cancelAtn = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func rememberMeBtnPressed(_ sender: Any) {
    
    }
}

