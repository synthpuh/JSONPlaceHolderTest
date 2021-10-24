//
//  PhotoModel.swift
//  JSONPlaceholderTest
//
//  Created by Ольга Шубина on 24.10.2021.
//

import UIKit

struct PhotoModel: AnyResponse {
    
    var id: Int
    var albumId: Int
    var title: String
    var url: String
}

typealias PhotosModelResponse = [PhotoModel]
