//
//  TeamPlayersTableViewController.swift
//  Sports
//
//  Created by user242921 on 5/11/24.
//

import UIKit

class TeamPlayersTableViewController: UITableViewController {
    var viewModel : TeamViewModel!
    override func viewDidLoad() {
        
        super.viewDidLoad()

    
        viewModel.fetchData {
            self.tableView.reloadData()
            print(self.viewModel.getTeam()?.teamName ?? "NO Player")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.getPlayerCount()+1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamcellid", for: indexPath) as! TeamCell
            
            let curr = viewModel.getTeam()
            
            cell.nameLabel.text = curr?.teamName
            cell.img.kf.setImage(with: URL(string: curr?.teamLogo ?? ""))
            cell.contentView.layer.borderWidth=3
            cell.contentView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            cell.contentView.clipsToBounds = false
            cell.contentView.layer.cornerRadius = 15

            cell.contentView.backgroundColor = UIColor.white
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "playercellid", for: indexPath) as! PlayerCell
            
            var curr = viewModel.getPlayerAtIndex(i: indexPath.row-1)
            
            cell.numberLabel.text = curr.playerNumber
            cell.img.kf.setImage(with: URL(string: curr.playerImage ))
            cell.nameLabel.text = curr.playerName
            cell.positionLabel.text = curr.playerType.rawValue
            
            cell.contentView.layer.borderWidth=3
            cell.contentView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
            cell.contentView.clipsToBounds = false
            cell.contentView.layer.cornerRadius = 30

            cell.contentView.backgroundColor = UIColor.white
            return cell
        }
        // Configure the cell...

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0){
            return 230
        }
        return 90
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
