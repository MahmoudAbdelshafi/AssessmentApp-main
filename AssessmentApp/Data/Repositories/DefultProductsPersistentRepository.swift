//
//  DefultProductsPersistentRepository.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.


import Foundation

final class DefultProductsPersistentRepository {
    
    private var productsResponseStorage: ProductsResponseStorage
    
    init(productsResponseStorage: ProductsResponseStorage) {
        self.productsResponseStorage = productsResponseStorage
    }
}

extension DefultProductsPersistentRepository: FavoriteProductsPersistentRepository {
    
    func fetchfavoriteProducts() async throws -> ProductsPage {
        let products = try await productsResponseStorage.fetchfavoriteProducts()
        return products.toProductsPageDomain()
    }
    
    func saveAsFavoriteProducts(products: ProductEntity) async {
        await productsResponseStorage.saveAsFavoriteProducts(product: products)
    }
    
    func removeFavorites() {
        productsResponseStorage.removeFavorites()
    }
}
