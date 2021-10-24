//
//  NetworkService.swift
//  JSONPlaceholderTest
//
//  Created by Ольга Шубина on 23.10.2021.
//

import UIKit

class NetworkService {
    
    let urlString = "https://jsonplaceholder.typicode.com"
    
    func fetchData(from resource: String, completion: @escaping ([AnyResponse]?) -> Void) {
        
        let urlResourceString = urlString + resource
        
        guard let url = URL(string: urlResourceString) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    
                    switch resource {
                    case "/users": let objects = try decoder.decode(UsersModelResponse.self, from: data)
                        completion(objects)
                    case "/albums": let objects = try decoder.decode(AlbumsModelResponse.self, from: data)
                        completion(objects)
                    case "/photos": let objects = try decoder.decode(PhotosModelResponse.self, from: data)
                        completion(objects)
                    default:
                        completion(nil)
                    }
                    
                } catch let jsonError {
                    print("JSONError: \(jsonError.localizedDescription)")
                    completion(nil)
                }
            }
        }.resume()
    }
}
