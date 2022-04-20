//
//  RegisterViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var referralTextField: UITextField!
    @IBOutlet weak var btnBox: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passTextField.delegate = self
        referralTextField.delegate = self
        
    }
    
    @IBAction func showRefField(_ sender: UIButton) {
        
        if expandButton.isSelected {
            expandButton.setImage(UIImage(named: "expand.png"), for: .normal)
            referralTextField.alpha = 0
        }else {
            expandButton.setImage(UIImage(named: "collapse.png"), for: .selected)
            referralTextField.alpha = 1
        }
        expandButton.isSelected = !expandButton.isSelected
    }
    
    
    @IBAction func checkBox(_ sender: UIButton) {
        
        if btnBox.isSelected {
            btnBox.setImage(UIImage(named: "square-50.png"), for: .normal)
            registerBtn.isEnabled = false
        }else {
            btnBox.setImage(UIImage(named: "approval-50.png"), for: .selected)
            registerBtn.isEnabled = true
        }
        btnBox.isSelected = !btnBox.isSelected
    }

    
    @IBAction func registerButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passTextField.text, !password.isEmpty, password.count >= 8 else {
                  return
              }
        
        AuthManager.shared.registerNewUser(email: email, password: password) { registered in
            
            if registered {
                print("Registered...")
                self.dismiss(animated: true, completion: nil)
            }else {
                print("User ID is already registered...")
            }
        }
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate {
    
}
