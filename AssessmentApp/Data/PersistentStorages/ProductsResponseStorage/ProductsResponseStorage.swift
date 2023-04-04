//
//  ProductsResponseStorage.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

protocol ProductsResponseStorage {
    func fetchfavoriteProducts() async throws -> ProductsDTO
    func saveAsFavoriteProducts(product: ProductEntity) async
    func removeFavorites()
}
