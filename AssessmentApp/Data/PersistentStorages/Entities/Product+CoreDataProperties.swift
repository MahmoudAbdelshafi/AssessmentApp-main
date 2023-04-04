//
//  Product+CoreDataProperties.swift
//  ProductsApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//
//

import Foundation
import CoreData

extension CoreDataProduct {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataProduct> {
        return NSFetchRequest<CoreDataProduct>(entityName: "CoreDataProduct")
    }
    
    @objc public class func insertProductObject(context: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: "CoreDataProduct", into: context)
    }
    
    @NSManaged public var costPrice: Int16
    @NSManaged public var id: String?
    @NSManaged public var img: String?
    @NSManaged public var retailPrice: Int16
    @NSManaged public var productDescription: String?
    @NSManaged public var name: String?
    
}

extension CoreDataProduct: Identifiable {
    
}

extension CoreDataProduct {
    
    static func toProductResponse(_ savedProducts: [CoreDataProduct]) -> ProductsDTO {
        var productsResponse = ProductsDTO()
        
        for product in savedProducts {
            let productResponse = ProductResponseDTO(barcode: "",
                                                     description: product.productDescription,
                                                     id: product.id,
                                                     imageURL: product.img,
                                                     name: product.name,
                                                     retailPrice: Int(product.retailPrice),
                                                     costPrice: Int(product.costPrice))
            
            productsResponse[productResponse.id ?? ""] = productResponse
        }
        return productsResponse
    }
}

extension ProductsDTO {
    
    func toProductCoreDataEntityForInserting(context: NSManagedObjectContext) -> [CoreDataProduct]? {
        var coreDataProduct: [CoreDataProduct] = []
        for value in self.values {
            if let productEntity = CoreDataProduct.insertProductObject(context: context) as? CoreDataProduct {
                productEntity.costPrice = Int16(value.costPrice ?? 0)
                productEntity.retailPrice = Int16(value.retailPrice ?? 0)
                productEntity.productDescription = value.description
                productEntity.name = value.name
                productEntity.img = value.imageURL
                productEntity.id = value.id
                coreDataProduct.append(productEntity)
            }
        }
        return coreDataProduct
    }
}

