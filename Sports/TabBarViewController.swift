//
//  TabBarViewController.swift
//  Sports
//
//  Created by user242921 on 5/10/24.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

    @IBOutlet weak var favButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate=self
        if #available(iOS 16.0, *) {
            favButton.isHidden=true
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.isKind(of: DetailsLeagueCollectionViewController.classForCoder()){
            if #available(iOS 16.0, *) {
                favButton.isHidden=false
            } else {
                // Fallback on earlier versions
            }
        }else{
            if #available(iOS 16.0, *) {
                favButton.isHidden=true
            } else {
                // Fallback on earlier versions
            }
        }
        
    }

    @IBAction func favAction(_ sender: Any) {
        print("favAction")
    }
    /*d
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
}
