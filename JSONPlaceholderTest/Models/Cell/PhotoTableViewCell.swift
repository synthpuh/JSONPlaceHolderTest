//
//  PhotoTableViewCell.swift
//  JSONPlaceholderTest
//
//  Created by Ольга Шубина on 25.10.2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    func set(photoModel: PhotoModel) {
        cellLabel.text = photoModel.title
        
        let cacheItemNumber = NSNumber(value: photoModel.id)
        
        if let cachedImage = UsersTableViewController.cache.object(forKey: cacheItemNumber) {
            print("Using a cached image for item: \(cacheItemNumber)")
            cellImageView.image = cachedImage
        } else {
            
            let url = URL(string: String(photoModel.url))
            do {
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    guard let image = UIImage(data: data) else { return }
                    self.cellImageView.image = image
                    UsersTableViewController.cache.setObject(image, forKey: cacheItemNumber)
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
}
