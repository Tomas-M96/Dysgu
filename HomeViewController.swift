//
//  HomeViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 29/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    let networkingService = NetworkingService()
    let alertService = AlertService()
    let defaults = UserDefaults.standard
    var news = [News]()
    
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func getNews(){
        networkingService.response(endpoint: "/news", method: "GET") { (result: Result<[News], Error>) in
            switch result {
            case .success(let decodedJSON):
                self.news = decodedJSON
                print(self.news)
                self.newsTable.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileSegue))
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "person.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsSegue))
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "gear")
        
        getNews()
        if let username = defaults.string(forKey: "Username") {
            usernameLabel.text = "Croeso, \(username)"
        }
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage?.clipsToBounds = true
        profileImage?.layer.borderWidth = 3.0
        profileImage?.layer.borderColor = UIColor.white.cgColor
        
        let alert = self.alertService.alert(message: "You unlocked the 'Croeso!' badge!")
        self.present(alert, animated: true)
    }
    
    @objc func profileSegue(){
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    @objc func settingsSegue(){
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath)
        let newNews = news[indexPath.row]
        cell.textLabel?.text = "Date: " + newNews.DatePosted
        cell.detailTextLabel?.text = newNews.Content
        return cell
    }
}
