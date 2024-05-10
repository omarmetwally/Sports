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
        
        setupActivityIndicator()
        activityIndicator.startAnimating()

    }

    func configureWithSport(sport: Sport) {
           viewModel = LeaguesViewModel(networkService: NetworkServices(), sport: sport)
           
           viewModel?.fetchData {
               self.tableView.reloadData()
               self.activityIndicator.stopAnimating()
           }
       }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedLeague = viewModel.leagues[indexPath.row]
        print("Selected League: \(selectedLeague.leagueName)")
    }

}
