//
//  UITableView+NibRegistering.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/25/21.
//

import UIKit

extension UITableView {
    
    func registerNibCell<T: UITableViewCell>(_ type: T.Type) {
        let description = String(describing: type)
        register(UINib(nibName: description, bundle: Bundle(for: type)), forCellReuseIdentifier: description)
    }
    
    func dequeCell<T: UITableViewCell>(_ indexPath: IndexPath, type: T.Type = T.self) -> T{
        let description = String(describing: type)
        if let cell = dequeueReusableCell(withIdentifier: description, for: indexPath) as? T {
            return cell
        }
        fatalError("failed to deque cell")
    }
}
