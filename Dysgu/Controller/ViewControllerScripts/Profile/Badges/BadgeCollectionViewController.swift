//
//  BadgeCollectionViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 12/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class BadgeCollectionViewController: UICollectionViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    var allBadges = [Badge]()
    var unlockedBadges = [UnlockedBadge]()

    
    func getAllBadges() {
        networkingService.response(endpoint: "/badges", method: "GET") { (result: Result<[Badge], Error>) in
            switch result {
                case .success(let decodedJSON):
                    self.allBadges = decodedJSON
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllBadges()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allBadges.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badge", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        for i in 0...unlockedBadges.count-1 {
            if unlockedBadges[i].BadgeID == allBadges[indexPath.item].BadgeID {
                print("unlocked")
                break
            }else{
                cell.imageView.image = UIImage(named: "locked.png")
                cell.backgroundColor = .systemGray
            }
            
        }
        
        cell.name.text = allBadges[indexPath.item].Name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defaults.set(allBadges[indexPath.item].BadgeID, forKey: "BadgeId")
        performSegue(withIdentifier: "badgeDetailSegue", sender: self)
        
        
    }
    

}
