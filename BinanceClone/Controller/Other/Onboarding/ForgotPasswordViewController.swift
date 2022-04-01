//
//  ForgotPasswordViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var labelOTP: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var labelNP: UILabel!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var labelCP: UILabel!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var changePassBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialState()
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendVerifyButton(_ sender: UIButton) {
        
        labelOTP.alpha = 1
        labelNP.alpha = 1
        labelCP.alpha = 1
        otpTextField.alpha = 1
        newPassword.alpha = 1
        confirmPassword.alpha = 1
        changePassBtn.alpha = 1
        emailTextField.alpha = 0
        sendBtn.alpha = 0
        
        guard let email = emailTextField.text, !email.isEmpty else {
            return
        }
        
        AuthManager.shared.resetPassword(with: email) { sent in
            
            if !sent {
                let alert = UIAlertController(title: "Hurray!", message: "A password reset link has been sent", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Error!", message: "There was an error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

        
    }
    
    @IBAction func changePasswordButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    func initialState () {
        
        labelOTP.alpha = 0
        labelNP.alpha = 0
        labelCP.alpha = 0
        otpTextField.alpha = 0
        newPassword.alpha = 0
        confirmPassword.alpha = 0
        changePassBtn.alpha = 0
        emailTextField.alpha = 1
        sendBtn.alpha = 1

    }
}
