//
//  UsersTableViewController.swift
//  JSONPlaceholderTest
//
//  Created by Ольга Шубина on 23.10.2021.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    static var cache = NSCache<NSNumber, UIImage>()
    
    var usersArray: [UserModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsersTable()

    }

    // MARK: - Table view methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = usersArray[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "fromUsersToPhotos", sender: usersArray[indexPath.row])
    }
    
    func loadUsersTable() {
        
        usersArray = []
        
        let networkService = NetworkService()
        
        networkService.fetchData(from: "/users") { [weak self] usersModelResponse in
            
            guard let users = usersModelResponse as? UsersModelResponse else { return }
            
            for user in users {
                DispatchQueue.main.async {
                    self?.usersArray.append(user)
                    self?.tableView.reloadData()
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? PhotosTableViewController, let sender = sender as? UserModel {
            
            destinationVC.user = sender
        }
    }

}
