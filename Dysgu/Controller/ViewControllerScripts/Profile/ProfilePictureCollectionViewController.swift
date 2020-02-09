//
//  ProfilePictureCollectionViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 08/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ProfilePictureCollectionViewController: UICollectionViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    let profilePics = ["Pic3.png", "Pic4.png", "Pic5.png", "Dragon1.png", "Dragon2.png"]
    
    //calls the networking service to update the user profile picture
    func updateProfile(parameters: [String : String]) {
        if let profileId = defaults.string(forKey: "ProfileId"){
            networkingService.request(endpoint: "/profiles/" + profileId, method: "PATCH", parameters: parameters) { (result: Result<Response, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        print(decodedJSON)
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        let alert = self.alertService.alert(message: error.localizedDescription)
                        self.present(alert, animated: true)
                        print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Displays the number of cells needed for the profile pictures
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePics.count
    }

    //sets the image of the cells to the profile picture of that index
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        cell.imageView.image = UIImage(named: profilePics[indexPath.item])
        return cell
    }
    
    //Calls the patchImage function when a picture has been selected
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parameters = ["Image": profilePics[indexPath.item]]
        updateProfile(parameters: parameters)
    }
}
