//
//  ProductsScenesDiContainer.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import UIKit

final class ProductsScenesDiContainer {
    
    // MARK: - Repositories
    
    func makeDefultProductsRepository() -> DefultProductsRepository {
        return DefultProductsRepository(baseAPI: makeBaseAPI())
    }
    
    func makeDefultFavoriteProductsPersistentRepository() -> FavoriteProductsPersistentRepository {
        return DefultProductsPersistentRepository(productsResponseStorage: CoreDataProductsResponseStorage())
    }
    
    func makeBaseAPI() -> BaseAPI {
        return BaseAPI.sharedInstance
    }
    
    // MARK: - Use Cases -
    
    func makeFetchProductsUseCase() -> FetchProductsUseCase {
        return DefaultFetchTopStoriesUseCase(productsRepository: makeDefultProductsRepository())
    }
    
    func makeFetchFavoriteProductsUseCase() -> FetchFavoriteProductsUseCase {
        return DefaultFetchFavoriteProductsUseCase(favoriteProductsPersistentRepository: makeDefultFavoriteProductsPersistentRepository())
    }
    
    //MARK: - View Models -
    
    func makeDefaultMainControllerViewModel(actions: ProductsViewModelActions) -> MainControllerViewModel {
        DefaultMainViewModel(fetchProductsUseCase: makeFetchProductsUseCase(),
                             fetchFavoriteUseCase: makeFetchFavoriteProductsUseCase(),
                             actions: actions)
    }
    
    
    func makeDefaultFavoriteViewModel() -> FavoriteViewModel {
         DefaultFavoriteViewModel(fetchFavoriteProductsUseCase: makeFetchFavoriteProductsUseCase())
    }
    // MARK: - Flow Coordinators -
    
    func makeProductsScenesFlowCoordinator(navigationController: UINavigationController) -> ProductsScenesFlowCoordinator {
        return ProductsScenesFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
}

// MARK: - Products Screens Flow Coordinator Dependencies -

extension ProductsScenesDiContainer:  ProductsScreensFlowCoordinatorDependencies {
    
    func makeMainScreenViewController(actions: ProductsViewModelActions) -> MainController {
        return MainController.create(with: makeDefaultMainControllerViewModel(actions: actions))
    }
    
    func makeDetailsScreenViewController(dataModel: ProductEntity) -> DetailController {
        return DetailController.create(detailsData: dataModel)
    }
    
    func makeFavoriteController() -> FavoriteController {
        return FavoriteController.create(with: makeDefaultFavoriteViewModel())
    }
    
}
