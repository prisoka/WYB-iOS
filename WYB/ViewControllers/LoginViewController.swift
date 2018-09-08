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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var email = ""
    private var password = ""
    private let networkClient = NetworkClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("login view controller")
        
        // Do any additional setup after loading the view.
                
        activityIndicator.isHidden = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.text = "walker@gmail.com"
        passwordTextField.text = "priscilla"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        self.isEditing = false
        email = emailTextField.text ?? "" // ?? means: if field is empty, set email to empty string
        password = passwordTextField.text ?? ""
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        networkClient.login(email: email, password: password, completionBlock: { (loginResponse,error)  in
            print("login success")
            
            let userDetails = loginResponse
//            let userType = userDetails?.user_type
            // print(userType)
            
//            let user = UserType(rawValue: "user")
            
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()

                if userDetails?.user_type == UserType.user {
                    self.displayAlert(message: "Sorry, this app is only available for WYB walkers")
                }
                
//                if case userType = user {
//                    self.displayAlert(message: "Sorry, this app is only available for WYB walkers")
//                }
                
                if let error = error {
                    self.displayAlert(message: error.error.message)
                } else {
                    //Do something with loginResponse here
                    self.performSegue(withIdentifier: "LoggedInSegue", sender: self)
                }
            }
        })
        
    }
    
    // instantiating and presenting alert box
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

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

}
