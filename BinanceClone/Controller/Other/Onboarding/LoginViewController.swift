//
//  LoginViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()


        emailTextField.delegate = self
        passTextField.delegate = self
    }
    
    @IBAction func loginToRegister(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passTextField.text, !password.isEmpty, password.count >= 8 else {
                  return
              }
        print(email)
        // Login Functionality
        AuthManager.shared.loginUser(email: email, password: password) { success in
            DispatchQueue.main.async {

                if success {
                    //user logged in
                    print("Login Button Success")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    // This is to get the SceneDelegate object from your view controller
                    // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(mainTabBarController)
                }else {
                    //error occured
                    let alert = UIAlertController(title: "LogIn Error", message: "We were unable to Log you in",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    

}


extension LoginViewController : UITextFieldDelegate {
    
}
