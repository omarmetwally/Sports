//
//  DetailsLeagueCollectionViewController.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import UIKit

class DetailsLeagueCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: DetailLeagueViewModelProtocol!
    private var activityIndicator: UIActivityIndicatorView!
    var isFav:Bool = false
    @IBOutlet weak var favBtn: UIButton!
    let fetchGroup = DispatchGroup()
    var headersShouldAppear: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: "PlaceholderCell")
        if(viewModel.isStored()){
            favBtn.setImage(UIImage(named: "star"), for: .normal)
            isFav=true
        }
        
        activityIndicator = Helper.setupActivityIndicator(in: self.collectionView)
        activityIndicator.startAnimating()
        
        setupCompositionalLayout()
        self.headersShouldAppear = true
        fetchGroup.enter()
        fetchEventData()
        
        fetchGroup.enter()
        fetchLatestResultsData()
        
        fetchGroup.enter()
        fetchTeamData()
        
        fetchGroup.notify(queue: .main) {
            
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
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width * 0.5), minScale)
                let alpha = scale
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                item.alpha = alpha
            }
        }
        return section
    }
    func createLatestResultsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.visibleItemsInvalidationHandler = { (visibleItems, point, environment) in
            visibleItems.forEach { item in
                let distanceFromCenter = abs((item.frame.midY - point.y) - environment.container.contentSize.height / 2)
                let normalizedDistance = min(distanceFromCenter / (environment.container.contentSize.height / 2), 1)
                
                let scale = 1 - (0.2 * normalizedDistance)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
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
            return max(1, viewModel.events.count)
        case .latestResults:
            return max (1,viewModel.latestResults.count)
        case .teams:
            return max (1,viewModel.teams.count)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch sectionType {
        case .upcomingEvents:
            if viewModel.events.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCollectionViewCell
                return cell
            }
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
            if viewModel.latestResults.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCollectionViewCell
                return cell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCollectionViewCell else {
                fatalError("EventCell not found")
            }
            let event = (indexPath.section == SectionType.upcomingEvents.rawValue) ? viewModel.events[indexPath.row] : viewModel.latestResults[indexPath.row]
            cell.configure(with: event)
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            return cell
        case .teams:
            if viewModel.teams.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! PlaceholderCollectionViewCell
                return cell
            }
            
            
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
            Helper.presentRemoveFromFavoritesAlert(from: self) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.favBtn.setImage(UIImage(named: "favourite"), for: .normal)
                strongSelf.viewModel.deleteFromFav()
                strongSelf.isFav = false
            }
        }else{
            Helper.presentAddToFavoritesAlert(from: self) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.favBtn.setImage(UIImage(named: "star"), for: .normal)
                strongSelf.viewModel.addToFav()
                strongSelf.isFav = true
            }
        }
    }
}
