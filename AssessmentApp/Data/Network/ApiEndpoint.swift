//
//  ApiEndpoint.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 03/04/2023.
//

import Foundation

enum ApiEndpoint {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    case getProducts
    
    /// Define all your endpoints here
}

extension ApiEndpoint {

    /// The path for every endpoint
    var path: String {
        switch self {
            
        case .getProducts:
            return "v3/4e23865c-b464-4259-83a3-061aaee400ba"
        }
    }
    
    /// The method for the endpoint
    var method: ApiEndpoint.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    /// The URL parameters for the endpoint (in case it has any)
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
}
