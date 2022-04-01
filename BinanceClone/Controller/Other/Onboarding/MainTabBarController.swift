//
//  MainTabBarController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 24/02/22.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    var isLogIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthManager.shared.checkIfLoggedIn { loggedIn in
            if loggedIn {
                isLogIn = true
            }
            else{
                isLogIn = false
            }
        }
        
    }
    
    


}
