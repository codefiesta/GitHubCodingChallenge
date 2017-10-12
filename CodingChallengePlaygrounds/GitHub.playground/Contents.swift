//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import GitHub

extension String {
    
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

//PlaygroundPage.current.needsIndefiniteExecution = true

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
        
        for repo in repos {
            pulls(repo)
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
        
        for pr in results {
            print("🔂 [\(pr.number)] \(pr.title) => \(pr.diffUrl)")
            files(pr)
        }
    }
}

func files(_ pr: GitHubPullRequest?) {
    GitHubClient.files(pr) { (files, error) in
        guard let files = files else {
            PlaygroundPage.current.finishExecution()
        }
        
        for file in files {
            print("📁 [\(file.name)] +\(file.additions) -\(file.deletions) \(file.changes)")
        }
        // All done, fininsh the execution
        PlaygroundPage.current.finishExecution()
    }
}

//run()

func patchFile() -> String? {
    guard let url = Bundle.main.url(forResource: "Patch1", withExtension: "txt") else {
        return nil
    }
    
    do {
        let string = try String(contentsOf: url)
        return string
    } catch {
        print("Error loading test patch file: \(error)")
    }
    return nil
}

func testPatchRegex() {
    
    guard let text = patchFile() else {
        return
    }
    print(text)
    let firstLinePattern = "^(.+)\n"
    
    do {
        let regex = try NSRegularExpression(pattern: firstLinePattern, options: .caseInsensitive)
        let matches = regex.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.utf16.count))
        if !matches.isEmpty {
            for match in matches {
                let range = match.range(at: 1)
                if let group = text.substring(with: range) {
                    print("🐳 \(group)")
                }
            }
        } else {
            print("💩")
        }
    } catch {
        print("Error: \(error)")
    }
    
}
testPatchRegex()

