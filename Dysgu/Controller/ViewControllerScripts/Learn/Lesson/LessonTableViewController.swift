//
//  LessonTableViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 29/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class LessonTableViewController: UITableViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    var lesson: Lesson?
    var contents = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLessonContent()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Quiz", style: .plain, target: self, action: #selector(quizSegue))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @objc func quizSegue() {
        performSegue(withIdentifier: "quizSegue", sender: self)
    }
    
    func getLessonContent(){
        if let lessonId = lesson?.LessonID {
            networkingService.response(endpoint: "/lessons/" + lessonId + "/content", method: "GET") { (result: Result<[Content], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.contents = decodedJSON
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath)
        let content = contents[indexPath.row]
        cell.textLabel?.text = content.English
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Content") as? LessonContentViewController{
                vc.content = contents[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quizSegue" {
            if let vc = segue.destination as? QuizViewController {
                vc.contents = contents
            }
        }
    }
}
