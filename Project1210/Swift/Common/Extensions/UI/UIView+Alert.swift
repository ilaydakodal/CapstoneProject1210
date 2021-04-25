//
//  UIView+Alert.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import UIKit

extension UIViewController {
    
    func showError(_ title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
