//
//  HomeViewController.swift
//  Sports
//
//  Created by user242921 on 5/10/24.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var images:[String] = []
    
    @IBOutlet weak var colectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = 200.0
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let initialTransform = CGAffineTransform(translationX: -100, y: 0)
        cell.transform = initialTransform
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.7, delay: 0.7, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportCollectionCell", for: indexPath) as! SportsCollectionViewCell
        
        cell.sportImage.image = UIImage(named: images[indexPath.row])
        cell.sportImage.layer.cornerRadius=15
        
        
        //        let screenSize: CGRect = UIScreen.main.bounds
        //        cell.sportImage.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.4, height: screenSize.height * 0.4)
        cell.sportNameLabel.text = images[indexPath.row]
        cell.sportNameLabel.setContentHuggingPriority(.sceneSizeStayPut, for: .horizontal)
        cell.sportImage.setContentHuggingPriority(.sceneSizeStayPut, for: .horizontal)
        
        
        
        cell.contentView.layer.borderWidth=3
        cell.contentView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.cornerRadius = 15
        
        cell.contentView.backgroundColor = UIColor.white
        // Configure the cell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Helper.isConnectedToNetwork(){
            let sports: [Sport] = [.football, .basketball, .tennis, .cricket]
            let selectedSport = sports[indexPath.row]
            
            let networkService = NetworkServices()
            
            let viewModel = LeaguesViewModel(networkService: networkService,sport: selectedSport)
            if let leagueListScreen = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController {
                leagueListScreen.viewModel = viewModel
                navigationController?.pushViewController(leagueListScreen, animated: true)
            }        } else {
                Helper.presentNetworkAlert(from: self)
            }
        
    }
    
    @IBOutlet weak var connectionErrorImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = ["FOOTBALL","BASKETBALL","TENNIS","CRICKET"]
        
        
        // Register cell classes
        colectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
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
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
