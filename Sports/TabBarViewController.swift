//
//  TabBarViewController.swift
//  Sports
//
//  Created by user242921 on 5/10/24.
//

import UIKit

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 1, let navController = viewController as? UINavigationController {
            if let tableViewController = navController.viewControllers.first as? TableViewController {
                tableViewController.viewModel?.fetchData {
                    DispatchQueue.main.async {
                        tableViewController.tableView.reloadData()
                        tableViewController.updateTableBackground()
                    }
                }
            }
        }
    }
}
