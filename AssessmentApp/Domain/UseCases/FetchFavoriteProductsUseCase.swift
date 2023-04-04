//
//  FetchFavoriteProductsUseCase.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 03/04/2023.
//

import Foundation

protocol FetchFavoriteProductsUseCase {
    func execute() async -> ProductsPage?
    func saveAsFavorite(product: ProductEntity) async
    func removeFavorites()
    func getFavoriteProductsIDs() async -> [String]
}

final class DefaultFetchFavoriteProductsUseCase: FetchFavoriteProductsUseCase {
    
    //MARK: - Properties -
    
    private let favoriteProductsPersistentRepository: FavoriteProductsPersistentRepository
    
    //MARK: - Init -
    
    init(favoriteProductsPersistentRepository: FavoriteProductsPersistentRepository) {
        self.favoriteProductsPersistentRepository = favoriteProductsPersistentRepository
    }
    
    //MARK: - Methods -
    
    func execute() async -> ProductsPage? {
        do {
            return try await favoriteProductsPersistentRepository.fetchfavoriteProducts()
        } catch {
            
        }
        return nil
    }
    
    func saveAsFavorite(product: ProductEntity) async {
        await favoriteProductsPersistentRepository.saveAsFavoriteProducts(products: product)
    }
    
    func removeFavorites() {
        favoriteProductsPersistentRepository.removeFavorites()
    }
    
    func getFavoriteProductsIDs() async -> [String] {
        do {
            let products =  await execute()
            return products?.products.map{$0.id} ?? []
        }
    }
}
