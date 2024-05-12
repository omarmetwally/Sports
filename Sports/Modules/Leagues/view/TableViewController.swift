//
//  TableViewController.swift
//  Sports
//
//  Created by Omar on 10/05/2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    var viewModel: LeaguesDisplayable?
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Table viewDidLoad")
        self.navigationItem.title="Leagues"
        activityIndicator = Helper.setupActivityIndicator(in: self.tableView)
        setupViewModelForFavorite()
        guard let viewModel = viewModel else {
            print("ViewModel not set. Returning early.")
            return
        }
        
        activityIndicator.startAnimating()
        viewModel.fetchData {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            
        }
    }
    private func setupViewModelForFavorite() {
        if viewModel == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let coreDataService = CoreDataServices(managedContext: managedContext)
            viewModel = FavoriteLeaguesViewModel(coreDataService: coreDataService)
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.leagues.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueTableViewCell,
              let league = viewModel?.leagues[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: league)
        cell.contentView.layer.borderWidth=2
        cell.contentView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appdelegate.persistentContainer.viewContext
        
        let selectedLeague = viewModel!.leagues[indexPath.row]
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsLeagueCollectionViewController") as? DetailsLeagueCollectionViewController {
            detailsVC.viewModel = DetailsLeagueViewModel(networkService: NetworkServices(),coreDataService: CoreDataServices(managedContext: managedContext), leagueId: String(selectedLeague.leagueKey),sportName: viewModel!.sport ?? .football,league: selectedLeague)
            detailsVC.viewModel.delegate = self
            
            let navigationController = UINavigationController(rootViewController: detailsVC)
            navigationController.modalPresentationStyle = .popover
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewModel is FavoriteLeaguesViewModel {
            return .delete
        } else {
            return .none
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let favViewModel = viewModel as? FavoriteLeaguesViewModel {
                let league = favViewModel.leagues[indexPath.row]
                favViewModel.delete(league: league) {
                    favViewModel.fetchData {
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }
                }
            }
        }
    }

    
}


extension TableViewController: FavoriteUpdateDelegate {
    func favoritesDidUpdate() {
        print("Delegate: favoritesDidUpdate")
        activityIndicator.startAnimating()
        viewModel?.fetchData {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
