//
//  AdminPageViewController.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/18/21.
//

import UIKit

class AdminPageViewController: UIViewController {
    
    @IBOutlet weak var addSymptomsButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var userListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSymptomsButton.applyDefaultStyling(color: .black)
        logButton!.applyDefaultStyling(color: .black)
        userListButton!.applyDefaultStyling(color: .black)
    }
    
    @IBAction func addSymptomsButtonPressed(_ sender: UIButton) {
        let vc = AdminSymptomViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logButtonPressed(_ sender: UIButton) {
        
        
    }
    
    let userTable = UserListTableViewController()
    
    @IBAction func userListButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.userTable.modalPresentationStyle = .fullScreen
            self.present(self.userTable, animated: true, completion: nil)
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainPage = storyBoard.instantiateViewController(withIdentifier: "mainView") as! MainPageViewController
            mainPage.modalPresentationStyle = .fullScreen
            self.present(mainPage, animated: true, completion: nil)
        }
    }
}
