//
//  ProductsScreensFlow.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation
import UIKit

protocol ProductsScreensFlowCoordinatorDependencies {
    func makeMainScreenViewController(actions: ProductsViewModelActions) -> MainController
    func makeDetailsScreenViewController(dataModel: ProductEntity) -> DetailController
    func makeFavoriteController() -> FavoriteController
}

final class ProductsScenesFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ProductsScreensFlowCoordinatorDependencies
    
    private weak var productsVC: MainController?
    
    init(navigationController: UINavigationController,
         dependencies: ProductsScreensFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let action = ProductsViewModelActions(showProductDetails: navigateToProductDetailsScreen(_:),
                                              presentFavoritesScreen: { [weak self] in self?.presentfavoriteScreen() })
        let vc = dependencies.makeMainScreenViewController(actions: action)
        
        navigationController?.pushViewController(vc, animated: false)
        productsVC = vc
    }
    
    private func navigateToProductDetailsScreen(_ dataModel: ProductEntity) {
        let vc = dependencies.makeDetailsScreenViewController(dataModel: dataModel)
        productsVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentfavoriteScreen() {
        let vc = dependencies.makeFavoriteController()
        productsVC?.present(vc, animated: true)
    }
}
