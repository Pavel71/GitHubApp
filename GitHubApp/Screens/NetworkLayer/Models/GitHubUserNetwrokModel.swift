//
//  GitHubUserNetwrokModel.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


struct UsersSearchResult: Decodable {
    let totalCount : Int
    let users      : [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case users = "items"
        case totalCount 
    }
}

struct GitHubUser : Decodable,UserListCellable {

  
    var avatarUrl    : URL
    var username     : String
    let url          : URL
//    let htmlUrl      : URL
    var reposUrl     : URL
    var type         : String
    
    
    enum CodingKeys  : String, CodingKey {
        case avatarUrl
        case username = "login"
        case url
//        case htmlUrl
        case reposUrl
        case type
    }
}
