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
    private var emptyBackgroundView: UIView?
    private var isNetworkAvailable = true
    private var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Table viewDidLoad")
        let nib = UINib(nibName: "LeagueCell", bundle: nil)
           tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
            
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
            self.updateTableBackground()
            self.activityIndicator.stopAnimating()
            
        }
    }
    
    private func setupViewModelForFavorite() {
        if viewModel == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let coreDataService = CoreDataServices(managedContext: managedContext)
            viewModel = FavoriteLeaguesViewModel(coreDataService: coreDataService)
            isFavorite=true
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.leagues.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
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
        
        if Helper.isConnectedToNetwork(){
            navigateToDetails(for: indexPath)
        } else {
            Helper.presentNetworkAlert(from: self)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewModel is FavoriteLeaguesViewModel {
            return .delete
        } else {
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let initialTransform = CGAffineTransform(translationX: -100, y: 0)
        cell.transform = initialTransform
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
        })
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let favViewModel = viewModel as? FavoriteLeaguesViewModel {
                let league = favViewModel.leagues[indexPath.row]
                Helper.presentRemoveFromFavoritesAlert(from: self) {
                    favViewModel.delete(league: league) {
                        favViewModel.fetchData {
                            DispatchQueue.main.async {
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                self.updateTableBackground()
                            }
                        }
                    }
                }
            }
        }
    }
    func updateTableBackground() {
        if viewModel?.leagues.isEmpty ?? true {
            if emptyBackgroundView == nil {
                let noDataImage = UIImage(named: "noFavoritess")
                let imageView = UIImageView(image: noDataImage)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                emptyBackgroundView = UIView(frame: tableView.bounds)
                emptyBackgroundView?.addSubview(imageView)
                
                imageView.centerXAnchor.constraint(equalTo: emptyBackgroundView!.centerXAnchor).isActive = true
                imageView.centerYAnchor.constraint(equalTo: emptyBackgroundView!.centerYAnchor).isActive = true
                imageView.widthAnchor.constraint(equalTo: emptyBackgroundView!.widthAnchor, multiplier: 0.6).isActive = true
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            }
            
            tableView.backgroundView = emptyBackgroundView
        } else {
            tableView.backgroundView = nil
        }
    }
    private func navigateToDetails(for indexPath: IndexPath) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appdelegate.persistentContainer.viewContext
        let selectedLeague = viewModel!.leagues[indexPath.row]
        var sportOfLeague =  viewModel!.sport
        if isFavorite{
            sportOfLeague = selectedLeague.sport
        }
        
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsLeagueCollectionViewController") as? DetailsLeagueCollectionViewController {
            detailsVC.viewModel = DetailsLeagueViewModel(networkService: NetworkServices(), coreDataService: CoreDataServices(managedContext: managedContext), leagueId: String(selectedLeague.leagueKey), sportName: sportOfLeague ?? .football, league: selectedLeague)
            detailsVC.viewModel.delegate = self
            let navigationController = UINavigationController(rootViewController: detailsVC)
            navigationController.modalPresentationStyle = .popover
            self.present(navigationController, animated: true, completion: nil)
        }
        
    }
}


extension TableViewController: FavoriteUpdateDelegate {
    func favoritesDidUpdate() {
        print("Delegate: favoritesDidUpdate")
        activityIndicator.startAnimating()
        viewModel?.fetchData {
            self.tableView.reloadData()
            self.updateTableBackground()
            self.activityIndicator.stopAnimating()
        }
    }
}
