//
//  AuthManager.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 23/02/22.
//

import Foundation
import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    public func checkIfLoggedIn(completion: (Bool) -> Void)  {
        if Auth.auth().currentUser != nil {
          completion(true)
        } else {
            completion(false)
        }
    }
    
    public func registerNewUser(email: String, password: String, completion: @escaping (Bool) -> Void ) {

        DatabaseManager.shared.canCreateNewUser(with: email) { canCreate in
            
            if canCreate {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    
                    guard result != nil, error == nil else{
                        completion(false)    //Firebase could not create account
                        return
                    }
                    //Insert into database
                    DatabaseManager.shared.insertNewUser(with: email) { inserted in
                        if inserted {
                            completion(true)
                            return
                        }else {
                            completion(false)
                            return
                        }
                    }
                }
            }else {
                completion(false)
            }
        }
    }
    
    
    public func loginUser(email: String?, password: String, completion: @escaping (Bool) -> Void) {
        
        if let email = email {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
                
            }
        }
    }
    
    public func logout(completion: (Bool) -> Void) {
        
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }
    
    
    public func resetPassword(with email: String, completion: @escaping (Bool) -> Void ) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            
            if error == nil {
                completion(false)
                return
            }else {
                completion(true)
            }

        }
    }
}
