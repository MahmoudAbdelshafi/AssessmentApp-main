//
//  BaseAPI.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 03/04/2023.
//

import Foundation


protocol BaseAPIProtocol {
    func request<D: Codable>(router: ApiEndpoint) async throws -> D
}

final class BaseAPI: BaseAPIProtocol {
    
    typealias NetworkResponse = (data: Data, response: URLResponse)
    
    static let sharedInstance = BaseAPI()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func request<D: Decodable>(router: ApiEndpoint) async throws -> D {
        let request = try createRequest(from: router)
        let response: NetworkResponse = try await session.data(for: request)
        return try decoder.decode(D.self, from: response.data)
    }
}

private extension BaseAPI {
    
    func createRequest(from endpoint: ApiEndpoint) throws -> URLRequest {
        guard
            let urlPath = URL(string: ApiHelper.baseURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: urlPath.path)
        else {
            throw ApiError.invalidPath
        }
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

