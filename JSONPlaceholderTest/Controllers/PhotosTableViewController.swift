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
        
        loadAlbums(of: user)
        
        loadPhotos(of: albumsArray)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusePhotoCellIdentifier", for: indexPath)
        
        configureCell(cell, for: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, for index: IndexPath) {
        
        cell.textLabel?.text = String(photosArray[index.row].id)
        cell.imageView?.image = UIImage(systemName: "square.and.arrow.up")
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
            
            for album in albums {
                
                if album.userId == user.id {
                    
                    DispatchQueue.main.async {
                        self?.albumsArray.append(album)
                        self?.tableView.reloadData()
                    }
                }
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
                for photo in photos {
                   
                    if photo.albumId == album.id {
                        DispatchQueue.main.async {
                            self?.photosArray.append(photo)
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
