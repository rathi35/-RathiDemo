//
//  CryptoService.swift
//  RathiDemo
//
//  Created by Rathi Shetty on 12/12/24.
//

import Foundation

/// Service responsible for fetching crypto data from the API
class CryptoService {
    private let urlString = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
    
    /// Fetch the list of crypto coins
    /// - Parameter completion: Completion handler that returns either an array of Crypto objects or an error
    func fetchCoins(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Return the error
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }
            
            do {
                // Decode the JSON response into Crypto objects
                let coins = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(coins))
            } catch {
                completion(.failure(error)) // Return decoding error
            }
        }
        task.resume()
    }
}
