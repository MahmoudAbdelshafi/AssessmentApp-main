//
//  DefultProductsRepository.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

final class DefultProductsRepository {
    
    private let baseAPI: BaseAPI
    
    init(baseAPI: BaseAPI?) {
        self.baseAPI = baseAPI ?? BaseAPI.sharedInstance
    }
    
}

extension DefultProductsRepository: ProductsRepository {
    
    func fetchProductsList() async throws -> ProductsPage {
        do {
            let requestProductsDTO: ProductsDTO = try await baseAPI.request(router: .getProducts)
            return requestProductsDTO.toProductsPageDomain()
        } catch {
            debugPrint(error)
            throw error
        }
    }

}
