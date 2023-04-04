//
//  ProductsPersistentRepository.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

protocol FavoriteProductsPersistentRepository {
    func fetchfavoriteProducts() async throws -> ProductsPage
    func saveAsFavoriteProducts(products: ProductEntity) async
    func removeFavorites()
}
