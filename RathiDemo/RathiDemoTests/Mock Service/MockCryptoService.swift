//
//  MockCryptoService.swift
//  RathiDemoTests
//
//  Created by Rathi Shetty on 13/12/24.
//

import Foundation
@testable import RathiDemo

// Mock version of the CryptoService to simulate fetching data from a JSON file
class MockCryptoService: CryptoService {
    var result: Result<[Crypto], Error>?
    
    override func fetchCoins(request: APIRequest, completion: @escaping (Result<[Crypto], Error>) -> Void) {
        if let result = result {
            completion(result)
        } else {
            // Default to reading the mock JSON if no result is provided
            if let url = Bundle(for: MockCryptoService.self).url(forResource: "mockCryptos", withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                    completion(.success(cryptos))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
