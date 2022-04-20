//
//  AccountViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AccountCellModel {
    let title : String
    let icon  : UIImage
    let handler: ( () -> Void)
}


class AccountViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var data = [[AccountCellModel]]()
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref.observeSingleEvent(of: .value) { snapshot in
            
            if !snapshot.exists() { return }
            
            if let email = (snapshot as AnyObject)["email"] as? String {
                print("==>>1",email)
            }
        }
        
        configureModels()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func configureModels() {
        let section = [
            
            AccountCellModel(title: "My Referral ID", icon: UIImage(named: "addPerson.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Gift Card", icon: UIImage(named: "gift-card.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Notification", icon: UIImage(named: "notification.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Payment Methods", icon: UIImage(named: "payment.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Security", icon: UIImage(named: "security.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Settings", icon: UIImage(named: "settings.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Help & Support", icon: UIImage(named: "help.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Share the App", icon: UIImage(named: "share.png")!, handler: {
                self.handleDefault()
            }),
            AccountCellModel(title: "Log Out", icon: UIImage(named: "logout.png")!) { [weak self] in
                self?.didTapLogout()
            }
        ]
        
        data.append(section)
    }
    
    private func didTapLogout() {
        
        AuthManager.shared.logout { success in
            DispatchQueue.main.async {
                if success {
                    print("You are Logged out")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(loginNavController)
                }
                else {
                    print("Error Occured")
                }
            }
        }
    }
    
    private func handleDefault() {
        print("The Default button is pressed.")
    }
    
}

//MARK: - Extensions

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        cell.iconView.image = data[indexPath.section][indexPath.row].icon
        cell.label?.text = data[indexPath.section][indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let didTap = data[indexPath.section][indexPath.row]
        didTap.handler()
    }
    
    
}
