//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import GitHub

PlaygroundPage.current.needsIndefiniteExecution = true

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

