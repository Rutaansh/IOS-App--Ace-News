//
//  APICaller.swift
//  Ace
//
//  Created by Rutaansh Nambiar on 08/06/21.
//

import Foundation
final class APICaller{
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string:
            "https://newsapi.org/v2/top-headlines?country=us&apiKey=cedbb31f74d84f8cbcb8ecddc0ee6abf")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data,_, error in
            if let error = error {
                completion(.failure(error))
                
            }
            else if let data = data{
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

//models

struct APIResponse: Codable{
    let articles: [Article]
    }
struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt :String
    
}

struct Source: Codable {
    let name: String
    
}

