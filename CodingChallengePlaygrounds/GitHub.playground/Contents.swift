//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import GitHub

PlaygroundPage.current.needsIndefiniteExecution = true


func run() {

    // Find the users and chain the requests
    GitHubClient.users(query: "CosmicMind") { (result, error) in
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
    
    GitHubClient.repos(user) { (repos, error) in
        guard let repos = repos, !repos.isEmpty else {
            PlaygroundPage.current.finishExecution()
        }
        
        for (index, repo) in repos.enumerated() {
            pulls(repo)
            if index == repos.count {
                // All done, fininsh the execution
                PlaygroundPage.current.finishExecution()
            }
        }
    }
}

func pulls(_ repo: GitHubRepo?) {
    
    guard let repo = repo else {
        PlaygroundPage.current.finishExecution()
    }
    print("😼 \(repo)")
    
    GitHubClient.pulls(repo) { (results, error) in
        guard let results = results else {
            PlaygroundPage.current.finishExecution()
        }
        
        for result in results {
            print("🔂 [\(result.number)] \(result.title) => \(result.diffUrl)")
        }
    }
}


run()

