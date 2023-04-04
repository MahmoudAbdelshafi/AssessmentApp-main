//
//  AppDIContainer.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - DIContainers of scenes
    
    func makeProductsScenesDIContainer() -> ProductsScenesDiContainer {
      return ProductsScenesDiContainer()
    }
}
