//
//  DetailsLeagueCollectionViewController.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import UIKit

class DetailsLeagueCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: DetailsLeagueViewModel!
    private var activityIndicator: UIActivityIndicatorView!
    var isFav:Bool = false
    @IBOutlet weak var favBtn: UIButton!
    let fetchGroup = DispatchGroup()
    var headersShouldAppear: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(viewModel.isStored()){
            favBtn.setImage(UIImage(named: "star"), for: .normal)
            isFav=true
        }
        
        activityIndicator = Helper.setupActivityIndicator(in: self.collectionView)
        activityIndicator.startAnimating()
        
        setupCompositionalLayout()
        fetchGroup.enter()
        fetchEventData()
        
        fetchGroup.enter()
        fetchLatestResultsData()
        
        fetchGroup.enter()
        fetchTeamData()
        
        fetchGroup.notify(queue: .main) {
            self.headersShouldAppear = true
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
        
        
    }
    
    func fetchEventData() {
        viewModel.fetchEvents {
            self.fetchGroup.leave()
            
        }
    }
    
    func fetchLatestResultsData() {
        viewModel.fetchLatestResults {
            self.fetchGroup.leave()
            
        }
    }
    func fetchTeamData(){
        viewModel.fetchTeams {
            self.fetchGroup.leave()
            
        }
    }
    
    func setupCompositionalLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            guard let section = SectionType(rawValue: sectionIndex) else { return nil }
            var sectionLayout: NSCollectionLayoutSection?
            
            switch section {
            case .upcomingEvents:
                sectionLayout = self.createEventsSectionLayout()
            case .latestResults:
                sectionLayout = self.createLatestResultsSectionLayout()
            case .teams:
                sectionLayout = self.createTeamsSectionLayout()
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            sectionLayout?.boundarySupplementaryItems = [header]
            
            return sectionLayout
        }
    }
    
    
    func createDefaultSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createEventsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    func createLatestResultsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func createTeamsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .upcomingEvents:
            return viewModel.events.count
        case .latestResults:
            return viewModel.latestResults.count
        case .teams:
            return viewModel.teams.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch sectionType {
        case .upcomingEvents:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCollectionViewCell else {
                fatalError("EventCell not found")
            }
            let event = (indexPath.section == SectionType.upcomingEvents.rawValue) ? viewModel.events[indexPath.row] : viewModel.latestResults[indexPath.row]
            cell.configure(with: event)
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.scoreLabel.isHidden=true
            return cell
        case .latestResults:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCollectionViewCell else {
                fatalError("EventCell not found")
            }
            let event = (indexPath.section == SectionType.upcomingEvents.rawValue) ? viewModel.events[indexPath.row] : viewModel.latestResults[indexPath.row]
            cell.configure(with: event)
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            return cell
        case .teams:
            
            
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as? TeamSmallCell else {
                fatalError("EventCell not found")
            }
            let team = viewModel.teams[indexPath.row]
            cell.configure(with: team)
            cell.contentView.layer.cornerRadius = 30
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            return cell
            
            
            //return collectionView.dequeueReusableCell(withReuseIdentifier: "OtherCellIdentifier", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as? SectionHeaderView else {
            fatalError("Cannot create new header")
        }
        
        
        if headersShouldAppear {
            
            if let sectionType = SectionType(rawValue: indexPath.section) {
                switch sectionType {
                case .upcomingEvents:
                    headerView.configure(with: "Upcoming Events")
                case .latestResults:
                    headerView.configure(with: "Latest Results")
                case .teams:
                    headerView.configure(with: "Teams")
                }
            }
        }else{
            headerView.configure(with: "")
        }
        
        
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2{
            print(viewModel.teams[indexPath.row].teamKey ?? 0)
            let screen = storyboard?.instantiateViewController(withIdentifier: "teamdetails") as! TeamPlayersTableViewController
            let viewModel = TeamViewModel.init(network: NetworkServices(), sport: viewModel.sportName, id: viewModel.teams[indexPath.row].teamKey ?? 0)
            screen.viewModel=viewModel
            
            navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    @IBAction func favBtnAction(_ sender: Any) {
        print("pressed fav")
        if isFav{
            favBtn.setImage(UIImage(named: "favourite"), for: .normal)
            // delete from favourite here
            isFav=false
        }else{
            favBtn.setImage(UIImage(named: "star"), for: .normal)
            viewModel.addToFav()
            isFav=true
        }
    }
}