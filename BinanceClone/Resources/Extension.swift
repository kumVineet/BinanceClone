//
//  Extension.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 23/02/22.
//

import UIKit

extension String {
    
     func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    }
}

fileprivate var aView : UIView?

extension UIViewController {
    
    func showSpinner() {
        
        aView = UIView(frame: self.view.bounds)
        
        let ai = UIActivityIndicatorView()
        ai.style = .large
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}

//extension NumberFormatter {
//    func numberFormat() -> Double {
//    let formatter = NumberFormatter()
//    formatter.locale = .current
//    formatter.allowsFloats = true
//    formatter.formatterBehavior = .default
//    formatter.numberStyle = .currency
//    return formatter
//    }
//}
