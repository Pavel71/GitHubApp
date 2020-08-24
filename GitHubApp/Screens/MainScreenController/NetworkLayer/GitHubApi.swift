//
//  GitHubApi.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation


// MARK: - Api Errors

enum GitHubApiError: Error, LocalizedError, Identifiable {
    var id: String { localizedDescription }
    case urlError(URLError)
    case responseError(Int)
    case decodingError
    case genericError
    case apiError(Error)
    
    var localizedDescription: String {
        switch self {
        case .apiError(let error):
          return "Api Erorr,\(error.localizedDescription)"
        case .urlError(let error):
            return error.localizedDescription
            
        case .responseError(let status):
            return "Bad response code: \(status)"
            
        case .decodingError:
            return "Decoding Erorr"
        case .genericError:
            return "An unknown error has been occured"
        }
    }
}


// MARK: - Api Constants
struct APIConstants {
    // News  API key url: https://newsapi.org
//    static let apiKey: String = "e0518a295c20420fb48785de791a48a8"//"API_KEY"
    
    static let jsonDecoder: JSONDecoder = {
     let jsonDecoder = JSONDecoder()
     jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
     let dateFormatter        = DateFormatter()
     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
     jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
      return jsonDecoder
    }()
    
     static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - EndPoint
enum Endpoint {
  
  case userSearch(searchFilter: String)
  
  var baseURL : URL {URL(string: "https://api.github.com")!}
  
  func path() -> String {
    switch self {
    case .userSearch: return "/search/users"
    }
  }
  
  var absoluteURL: URL? {
      let queryURL = baseURL.appendingPathComponent(self.path())
      let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
      guard var urlComponents = components else {
          return nil
      }
      switch self {
      case .userSearch(let searchFilter):
        urlComponents.queryItems = [
          URLQueryItem(name: "q", value: searchFilter.lowercased())
        ]
    }
      return urlComponents.url
  }
}

// MARK: GitHubApi

final class GitHubApi {
  
  static let shared = GitHubApi()
  
  
  // fetch данные по запросу
  
  private func fetch(endPoint:Endpoint,
                     completion: @escaping (Data?,URLResponse?, Error?) -> Void) {
    guard let url = endPoint.absoluteURL else {return}
        
        
    let request = URLRequest(url: url)
    let task = createDataTask(from: request, completion: completion)
    task.resume()
    
  }
  // MARK: - Fetch Users
  func fetchUsers(userName: String,
                  completion: @escaping (Result<UsersSearchResult,GitHubApiError>) -> Void
                  ) {
    
    let endpoint:Endpoint = .userSearch(searchFilter: userName)
    
    fetch(endPoint: endpoint) { data,response, error in
      // Error
      if let error = error {
        completion(.failure(.apiError(error)))
      }
      // HTTP Response
      if let httpResponse  = response as? HTTPURLResponse,
        httpResponse.statusCode != 200 {
        completion(.failure(.responseError(httpResponse.statusCode)))
      }
      // Data
      if let data  = data {
        
        let results: UsersSearchResult? = self.convertNetworkDataToModel(data: data, type: UsersSearchResult.self)
        
        if let res = results  {
          completion(.success(res))
        } else {
          completion(.failure(.decodingError))
        }
      
      }
       
    }
    

  }
  
  private func convertNetworkDataToModel <T: Decodable>(
    data: Data,
    type: T.Type
    ) -> T? {
    do {
        let model = try APIConstants.jsonDecoder.decode(type.self, from: data)
        
        return model
      } catch (_) {
        return nil
      }
  }
  
  private func createDataTask(from request: URLRequest,completion: @escaping (Data?,URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    
    return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
      DispatchQueue.main.async {
        completion(data,response, error)
      }
    })
  }
  
  //fetch данные по поиску
  
}
