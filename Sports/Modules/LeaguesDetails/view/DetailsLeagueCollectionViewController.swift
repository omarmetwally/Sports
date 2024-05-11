//
//  DetailsLeagueCollectionViewController.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import UIKit

class DetailsLeagueCollectionViewController: UICollectionViewController {
    var viewModel: DetailsLeagueViewModel!
    private var activityIndicator: UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = Helper.setupActivityIndicator(in: self.collectionView)
        activityIndicator.startAnimating()
        
        setupCompositionalLayout()
        fetchEventData()
        
        
    }

    func fetchEventData() {
        viewModel.fetchEvents {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()

        }
    }

    func setupCompositionalLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self.createEventsSectionLayout()
            default:
                return self.createDefaultSectionLayout()
            }
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewModel.events.count : 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCollectionViewCell else {
                fatalError("EventCell not found")
            }
            let event = viewModel.events[indexPath.row]
            cell.configure(with: event)
            cell.contentView.layer.borderWidth=2
            cell.contentView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
           
            
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "OtherCellIdentifier", for: indexPath)
        }
    }
}
