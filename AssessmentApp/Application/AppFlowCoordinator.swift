//
//  AppFlowCoordinator.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let productsScenesDIContainer = appDIContainer.makeProductsScenesDIContainer()
        let flow = productsScenesDIContainer.makeProductsScenesFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
