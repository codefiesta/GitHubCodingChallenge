//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func apiTest() {

    let url = "https://api.github.com/search/users"
    let params: [String: String] = ["q": "CosmicMind"]
    request(url, params: params) { (data, error) in

        if let data = data, let string = String(data: data, encoding: String.Encoding.utf8) {
            print("Received data: \(string)")
        } else {
            print("No data received!")
        }
        
        PlaygroundPage.current.finishExecution()
    }
}

func request(_ urlString: String, params: [String: String]? = [:], _ completion: @escaping (Data?, Error?) -> Void) {

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
        
        return completion(data, nil)
    })
    
    dataTask.resume()

}

apiTest()

