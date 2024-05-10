//
//  TeamDetailsViewController.swift
//  Sports
//
//  Created by user242921 on 5/10/24.
//

import UIKit

class TeamDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var websiteImage: UIImageView!
    @IBOutlet weak var twitterImage: UIImageView!
    @IBOutlet weak var instgramImage: UIImageView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var TeamImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tableViewController = children[0] as? DetailsDelegate
        tableViewController?.updateLeague(val: "kolotmam")
        // Do any additional setup after loading the view.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
