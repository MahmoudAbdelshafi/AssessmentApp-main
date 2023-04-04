//
//  CoreDataProductsResponseStorage.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation
import CoreData

final class CoreDataProductsResponseStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataProductsResponseStorage {
    
    // MARK: - Private -
    
    private func clearData() {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = CoreDataProduct.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest)
                _ = requestEntity.map {context.delete($0)}
                try context.save()
            } catch {
                debugPrint(error)
            }
        }
    }
}

extension CoreDataProductsResponseStorage: ProductsResponseStorage {
    
    func removeFavorites() {
        clearData()
    }
    
    func fetchfavoriteProducts() async throws -> ProductsDTO {
        return await withCheckedContinuation { continuation in
            getSavedProducts { result in
                switch result {
                case .success(let productsDTO):
                    continuation.resume(returning: productsDTO)
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                }
            }
        }
    }
    
    func saveAsFavoriteProducts(product: ProductEntity) async {
        return await withCheckedContinuation { continuation in
            let newProduct = ProductResponseDTO(barcode: "",
                                                description: product.description,
                                                id: product.id,
                                                imageURL: product.imageURL,
                                                name: product.name,
                                                retailPrice: product.retailPrice,
                                                costPrice: product.costPrice)
            save(product: [newProduct.id! : newProduct]) { result in
                switch result {
                case .success(_):
                    continuation.resume(returning: ())
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                }
            }
            
        }
    }
    
    private func getSavedProducts(completion: @escaping (Result<ProductsDTO,
                                                         Error>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = CoreDataProduct.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest)
                let coreDataDTO = CoreDataProduct.toProductResponse(requestEntity)
                completion(.success(coreDataDTO))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func save(product: ProductsDTO,
              completion: @escaping (Result<[ProductResponseDTO], Error>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            Task {
                do {
                    var savedProducts: ProductsDTO = [:]
                    let products = try await self.fetchfavoriteProducts()
                    savedProducts = products
                    savedProducts [product.first?.key ?? ""] = product.first?.value
                    self.clearData()
                    
                    if let _ = savedProducts.toProductCoreDataEntityForInserting(context: context) {
                        do {
                            try context.save()
                        } catch {
                            ///Error
                        }
                    }
                }
                
            }
            
        }
        
    }
    
}
