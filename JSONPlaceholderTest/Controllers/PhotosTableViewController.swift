//
//  PhotosTableViewController.swift
//  JSONPlaceholderTest
//
//  Created by Ольга Шубина on 24.10.2021.
//

import UIKit

class PhotosTableViewController: UITableViewController {
    
    var user: UserModel?
    var albumsArray: [AlbumModel] = []
    var photosArray: [PhotoModel] = []
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadAlbums(of: user)
    }
    
    func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reusePhotoCellIdentifier")
        
        let nib = UINib(nibName: "PhotoTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "reusePhotoCellIdentifier")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusePhotoCellIdentifier", for: indexPath) as! PhotoTableViewCell
        
        cell.set(photoModel: photosArray[indexPath.row])
        
        return cell
    }
    
    func loadAlbums(of user: UserModel?) {
        
        albumsArray = []
        
        guard let user = user else {
            return
        }
        
        networkService.fetchData(from: "/albums") { [weak self] albumsResponse in
            
            guard let albums = albumsResponse as? AlbumsModelResponse else {
                return
            }
            
            DispatchQueue.main.async {
                self?.albumsArray = albums.filter { album in
                    album.userId == user.id
                }
                self?.loadPhotos(of: self?.albumsArray)
            }
        }
    }
    
    func loadPhotos(of albums: [AlbumModel]?) {
        
        photosArray = []
        
        guard let albums = albums else {
           return
        }
        
        networkService.fetchData(from: "/photos") { [weak self] photosResponse in
            
            guard let photos = photosResponse as? PhotosModelResponse else { return }
            
            for album in albums {
                
                DispatchQueue.main.async {
                    self?.photosArray.append(contentsOf: photos.filter({ photo in
                        photo.albumId == album.id
                    }))
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
