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
        return CGSize(width: UIScreen.main.bounds.size.width/2 - 10, height: UIScreen.main.bounds.size.height/4)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportCollectionCell", for: indexPath) as! SportsCollectionViewCell
        
        cell.sportImage.image = UIImage(named: images[indexPath.row])
        let screenSize: CGRect = UIScreen.main.bounds
        cell.sportImage.frame = CGRect(x: 0, y: 0, width: screenSize.width*0.4, height: screenSize.height * 0.4)
        cell.sportNameLabel.text = images[indexPath.row]
        
        // Configure the cell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sports: [Sport] = [.football, .basketball, .tennis, .cricket]
        let selectedSport = sports[indexPath.row]
        
        if let leagueListScreen = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController {
            leagueListScreen.configureWithSport(sport: selectedSport)
            navigationController?.pushViewController(leagueListScreen, animated: true)
        }
    }
    
    @IBOutlet weak var connectionErrorImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = ["football","basketball","tennis","cricket"]
        
        
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
    
}
