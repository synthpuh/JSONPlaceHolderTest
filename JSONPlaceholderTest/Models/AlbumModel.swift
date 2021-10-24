//
//  AlbumModel.swift
//  JSONPlaceholderTest
//
//  Created by Ольга Шубина on 24.10.2021.
//

import Foundation

struct AlbumModel: AnyResponse {
    
    var userId: Int
    var id: Int
}

typealias AlbumsModelResponse = [AlbumModel]
