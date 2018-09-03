//
//  LoginViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 2/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    private var email = ""
    private var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        print("login view controller")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        self.isEditing = false
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""

        print("Hello world")
        print(email)
        print(password)
        
        
    }
//
//    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        if let text = textField.text {
//            if(textField == emailTextField){
//                email = text
//            } else if(textField == passwordTextField) {
//                password = text
//            }
//        }
//    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
