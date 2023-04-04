//
//  ProductsPage.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

struct ProductsPage {
    let page: Int = 0
    let totalPages: Int = 200
    var products: [ProductEntity]
}

struct ProductEntity {
    let barcode, description, id: String
    let imageURL: String
    let name: String
    let retailPrice: Int
    let costPrice: Int
    var isFavorite = false
}
