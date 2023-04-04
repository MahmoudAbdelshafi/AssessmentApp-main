//
//  FetchProductsUseCase.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

protocol FetchProductsUseCase {
    func execute() async throws -> ProductsPage
}

final class DefaultFetchTopStoriesUseCase: FetchProductsUseCase {
    
    //MARK: - Properties -
    
    private let productsRepository: ProductsRepository
    
    //MARK: - Init -
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    //MARK: - Methods -
    
    func execute() async throws -> ProductsPage {
        try await productsRepository.fetchProductsList()
    }

}
