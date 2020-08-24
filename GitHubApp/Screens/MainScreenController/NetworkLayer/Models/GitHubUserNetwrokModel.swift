//
//  GitHubUserNetwrokModel.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


struct UsersSearchResult: Decodable {
    let users: [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}

struct GitHubUser : Decodable {
    let avatarUrl    : URL
    let username     : String
    let url          : URL
    let htmlUrl      : URL
    let reposUrl     : URL
    var avatarImage  : UIImage?
    var repositories : [Repository]?
    
    enum CodingKeys  : String, CodingKey {
        case avatarUrl
        case username = "login"
        case url
        case htmlUrl
        case reposUrl
    }
}
