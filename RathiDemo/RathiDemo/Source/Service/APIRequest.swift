//
//  APIRequest.swift
//  RathiDemo
//
//  Created by Rathi Shetty on 12/12/24.
//

import Foundation

enum APIRequest {

    // MARK: Crypo List Request.
    case crypoList

    var baseURL: String {
        switch self {
        default: return APIRequestContants.baseURL
        }
    }

    var path: String? {
        return nil
    }
}
