//
//  TableViewController.swift
//  Sports
//
//  Created by Omar on 10/05/2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    var viewModel: LeaguesViewModel!
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Leagues"
        activityIndicator = Helper.setupActivityIndicator(in: self.tableView)
        activityIndicator.startAnimating()

    }

    func configureWithSport(sport: Sport) {
           viewModel = LeaguesViewModel(networkService: NetworkServices(), sport: sport)
           
           viewModel?.fetchData {
               self.tableView.reloadData()
               self.activityIndicator.stopAnimating()
           }
       }
  

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.leagues.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueTableViewCell else {
            return UITableViewCell()
        }

        let league = viewModel.leagues[indexPath.row]
        cell.configure(with: league)
        cell.contentView.layer.borderWidth=2
        cell.contentView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appdelegate.persistentContainer.viewContext

        let selectedLeague = viewModel.leagues[indexPath.row]
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsLeagueCollectionViewController") as? DetailsLeagueCollectionViewController {
            detailsVC.viewModel = DetailsLeagueViewModel(networkService: NetworkServices(),coreDataService: CoreDataServices(managedContext: managedContext), leagueId: String(selectedLeague.leagueKey),sportName: viewModel.sport,league: selectedLeague)
            
            
            let navigationController = UINavigationController(rootViewController: detailsVC)
            navigationController.modalPresentationStyle = .popover
            self.present(navigationController, animated: true, completion: nil)
        }
    }

}
