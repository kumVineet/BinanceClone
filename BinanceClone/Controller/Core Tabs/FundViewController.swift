//
//  FundViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit

class FundViewController: UIViewController {

    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var depositImageView: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        depositView.layer.masksToBounds = true
        depositView.layer.cornerRadius = 10
        
        depositImageView.layer.masksToBounds = true
        depositImageView.layer.cornerRadius = depositImageView.bounds.width / 2
    }
    
    @IBAction func info(_ sender: UIButton) {
    }
    
    @IBAction func deposit(_ sender: UIButton) {
    }
    
    @IBAction func buyWithCash(_ sender: UIButton) {
    }
    

    
}
