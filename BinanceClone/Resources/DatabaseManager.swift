//
//  DatabaseManager.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 23/02/22.
//

import Foundation
import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func canCreateNewUser(with email: String, completion: (Bool) -> Void) {
        
        completion(true)
    }
    
    public func insertNewUser(with email: String,  completion: @escaping (Bool) -> Void) {
        
        let object : [String:Any] = ["email" : email]
        database.child("UserData_\(Int.random(in: 0..<100))").setValue(object) { error, _ in
            if error == nil {
                completion(true)
                return
            }else {
                completion(false)
                return
            }
        }
    }
}

/**
 database.child(email.safeDatabaseKey()).setValue(["email": email]) { error, _ in
     if error == nil {
         completion(true)
         return
     }else {
         completion(false)
         return
     }
 }
}
 */
