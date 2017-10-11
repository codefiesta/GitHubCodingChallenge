//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct GitHubSearchResults: Codable {
    
    var totalCount: Int
    var users: [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case users = "items"
    }
}

// Represents a User or Organization
struct GitHubUser: Codable {

    var login: String
    var avatarUrl: String
    var reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}

// Represents a Reop
struct GitHubRepo: Codable {

    var name: String
    var description: String
    var pullsUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case pullsUrl = "pulls_url"
    }

    // Use a custom decoder to cleanup the pulls url
    // This is done since we can't use the didSet {} observer since it won't fire inside an init() 😢
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        pullsUrl = try values.decode(String.self, forKey: .pullsUrl).replacingOccurrences(of: "{/number}", with: "")
    }
}

// Represents a PR
struct GitHubPR: Codable {
    
    var number: Int
    var title: String
    var state: String
    var diffUrl: String
    
    enum CodingKeys: String, CodingKey {
        case number
        case title
        case state
        case diffUrl = "diff_url"
    }
}

func users() {

    let url = "https://api.github.com/search/users"
    let params: [String: String] = ["q": "CosmicMind"]
    
    request(url, params: params) { (result: GitHubSearchResults?, error) in

        guard let result = result, !result.users.isEmpty else {
            PlaygroundPage.current.finishExecution()
        }
        
        repos(result.users.first)
    }
}

func repos(_ user: GitHubUser?) {
    
    guard let user = user else {
        PlaygroundPage.current.finishExecution()
    }

    print("🤔 \(user)")
    request(user.reposUrl) { (results: [GitHubRepo]?, error) in

        guard let results = results, !results.isEmpty else {
            PlaygroundPage.current.finishExecution()
        }

        for (index, repo) in results.enumerated() {
            prs(repo)
            if index == results.count {
                PlaygroundPage.current.finishExecution()
            }
        }
        
    }
}

func prs(_ repo: GitHubRepo?) {
    
    guard let repo = repo else {
        PlaygroundPage.current.finishExecution()
    }
    print("😼 \(repo)")
    request(repo.pullsUrl) { (results: [GitHubPR]?, error) in
        guard let results = results else {
            PlaygroundPage.current.finishExecution()
        }
        
        for result in results {
            print("🔂 [\(result.number)] \(result.title) => \(result.diffUrl)")
        }
    }
}


func request<T: Codable>(_ urlString: String, params: [String: String]? = [:], _ completion: @escaping (T?, Error?) -> Void) {

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
            let decoded: T = try jsonDecoder.decode(T.self, from: data)
            return completion(decoded, error)
            
        } catch {
            print("Error: \(error)" )
            return completion(nil, error)
        }

    })
    
    dataTask.resume()
}

users()

