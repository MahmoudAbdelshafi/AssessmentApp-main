//
//  ProductResponseDTO+Mapping.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

// MARK: - ProductResponseDTO -

struct ProductResponseDTO: Decodable {
    let barcode, description, id: String?
    let imageURL: String?
    let name: String?
    let retailPrice: Int?
    let costPrice: Int?

    enum CodingKeys: String, CodingKey {
        case barcode, description, id
        case imageURL = "image_url"
        case name
        case retailPrice = "retail_price"
        case costPrice = "cost_price"
    }
}

typealias ProductsDTO = [String: ProductResponseDTO]


// MARK: - Mappings to Domain -

extension ProductsDTO {
    
    func toProductsPageDomain() -> ProductsPage {
        var products = [ProductEntity]()

        for product in self.values {
            let productEntity = ProductEntity(barcode: product.barcode ?? "",
                                              description: product.description ?? "",
                                              id: product.id ?? "",
                                              imageURL: product.imageURL ?? "",
                                              name: product.name ?? "",
                                              retailPrice: product.retailPrice ?? 0,
                                              costPrice: product.costPrice ?? 0)
            products.append(productEntity)
        }

        let productsPage = ProductsPage(products: products)
        return productsPage
    }
}
