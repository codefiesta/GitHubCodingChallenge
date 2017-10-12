//
//  GitHubClient.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import Foundation

public struct GitHubClient {

    // Search for GitHub Users / Orgs
    public static func users(query: String?, _ completion: @escaping (GitHubSearchResults?, Error?) -> Void) {
        
        print("Finding 🤔")
        guard let query = query, !query.isEmpty else {
            return completion(nil, nil)
        }
        
        let url = "https://api.github.com/search/users"
        let params: [String: String] = ["q": query]
        
        request(url, params: params) { (result: GitHubSearchResults?, error) in
            return completion(result, error)
        }
    }

    // Fetches the repositories for the specified user
    public static func repos(_ user: GitHubUser?, _ completion: @escaping ([GitHubRepo]?, Error?) -> Void) {
        
        print("Finding 😼")

        guard let user = user else {
            return completion(nil, nil)
        }

        let params: [String: String] = ["sort": "pushed"]
        request(user.reposUrl, params: params) { (result: [GitHubRepo]?, error) in
            return completion(result, error)
        }
    }
    
    // Fetches the pull requests for the specified repo
    public static func pulls(_ repo: GitHubRepo?, _ completion: @escaping ([GitHubPullRequest]?, Error?) -> Void) {
        
        print("Finding 🔂 ")

        guard let repo = repo else {
            return completion(nil, nil)
        }

        let params: [String: String] = ["direction": "desc"]
        request(repo.pullsUrl, params: params) { (results: [GitHubPullRequest]?, error) in
            return completion(results, error)
        }
    }

    // Fetches the files for the specified PR
    public static func files(_ pr: GitHubPullRequest?, _ completion: @escaping ([GitHubPullRequestFile]?, Error?) -> Void) {
        
        guard let pr = pr else {
            return completion(nil, nil)
        }
        
        print("Finding 📄 -> \(pr.filesUrl)")

        request(pr.filesUrl) { (results: [GitHubPullRequestFile]?, error) in
            print("Found \(results?.count ?? 0) 📄")
            return completion(results, error)
        }
    }
}

// MARK: PRIVATE

extension GitHubClient {

    fileprivate static func request<T: Codable>(_ urlString: String, params: [String: String]? = [:], _ completion: @escaping (T?, Error?) -> Void) {
        
        let accessToken = "ba425f573c55a8043573bafba18d3ec41dd5a765"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            return completion(nil, nil)
        }
        
        if let params = params, !params.isEmpty {
            var queryItems: [URLQueryItem] = []
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            return completion(nil, nil)
        }
        
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5.0)
        request.httpMethod = "GET"
        request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                return completion(nil, error)
            }
            
            guard let data = data else {
                return completion(nil, error)
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601 // For date parsing
                let decoded: T = try jsonDecoder.decode(T.self, from: data)
                return completion(decoded, error)
                
            } catch {
                print("Error: \(error)" )
                return completion(nil, error)
            }
            
        })
        
        dataTask.resume()
    }
}
