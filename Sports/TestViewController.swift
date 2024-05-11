//
//  TestViewController.swift
//  Sports
//
//  Created by user242921 on 5/11/24.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    

        
    @IBAction func act(_ sender: Any) {
        let screen = storyboard?.instantiateViewController(withIdentifier: "teamdetails") as! TeamPlayersTableViewController
        let viewModel = TeamViewModel.init(network: NetworkServices(), sport: Sport.basketball, id: 30)
        screen.viewModel=viewModel
        
        navigationController?.pushViewController(screen, animated: true)
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
