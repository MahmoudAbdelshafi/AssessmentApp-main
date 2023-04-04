//
//  ProductsRepository.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

protocol ProductsRepository {
    func fetchProductsList() async throws -> ProductsPage
}
