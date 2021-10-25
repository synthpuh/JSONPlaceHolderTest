//
//  UsersModel.swift
//  JSONPlaceholderTest
//
//  Created by Ольга Шубина on 23.10.2021.
//

import Foundation

struct UserModel: AnyResponse {
    
    var id: Int
    var name: String
    
}

typealias UsersModelResponse = [UserModel]

protocol AnyResponse: Decodable {
    
}
