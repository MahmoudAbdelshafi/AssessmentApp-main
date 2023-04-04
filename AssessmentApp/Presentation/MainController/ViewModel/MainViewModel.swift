//
//  MainControllerViewModel.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import Foundation
import Combine

struct ProductsViewModelActions {
    let showProductDetails: (ProductEntity) -> Void
    let presentFavoritesScreen: () -> Void
}

enum ProductsListViewModelLoading {
    case nextPage
}

protocol ProductsViewModelOutput {
    var products: ProductsPage? { get }
}

enum InPut {
    case viewDidLoad
    case viewWillAppear
    case didSelectItem(index: Int)
    case saveAsFavorite(index: Int)
    case presentFavorites
}

enum OutPut {
    case dataLoaded
}

protocol ProductsViewModelInput {
}

protocol MainControllerViewModel: ProductsViewModelOutput, ProductsViewModelInput {
    func transform(input: AnyPublisher<InPut, Never>) -> AnyPublisher<OutPut, Never>
}

final class DefaultMainViewModel: MainControllerViewModel {
    
    //MARK: - Properties -
    
    private let fetchProductsUseCase: FetchProductsUseCase
    private let fetchFavoriteProductsUseCase: FetchFavoriteProductsUseCase
    private let actions: ProductsViewModelActions?
    private let output: PassthroughSubject<OutPut, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var products: ProductsPage?
    
    func transform(input: AnyPublisher<InPut, Never>) -> AnyPublisher<OutPut, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewDidLoad:
                viewDidLoad()
                
            case .didSelectItem(let index):
                didSelectItem(index)
                
            case .saveAsFavorite(let index):
                saveAsFavorite(index)
                
            case .presentFavorites:
                presentFavorites()
                
            case .viewWillAppear:
                viewWillAppear()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    //MARK: - Init -
    
    init(fetchProductsUseCase: FetchProductsUseCase,
         fetchFavoriteUseCase: FetchFavoriteProductsUseCase,
         actions: ProductsViewModelActions? = nil) {
        self.fetchProductsUseCase = fetchProductsUseCase
        self.fetchFavoriteProductsUseCase = fetchFavoriteUseCase
        self.actions = actions
    }
    
    private func fetchProducts() async {
        do {
            products = try await fetchProductsUseCase.execute()
            output.send(.dataLoaded)
        } catch {
            
        }
    }
    
    private func saveAsFavorite(_ index: Int)  {
        Task {
            guard let selectedProduct = products?.products[index] else { return }
            self.products?.products[index].isFavorite = true
            await fetchFavoriteProductsUseCase.saveAsFavorite(product: selectedProduct)
        }
    }
    
    private func presentFavorites() {
        actions?.presentFavoritesScreen()
    }
    
    private func getFavIDs() async {
        do {
            let favoriteIDs = await fetchFavoriteProductsUseCase.getFavoriteProductsIDs()
            guard let products else { return }
            for (index, porduct) in products.products.enumerated() {
                if favoriteIDs.contains(porduct.id) {
                    self.products?.products[index].isFavorite = true
                } else {
                    self.products?.products[index].isFavorite = false
                }
            }
            output.send(.dataLoaded)
        }
    }
    
}

// MARK: - INPUT. View event methods -

extension DefaultMainViewModel {
    
    private func viewDidLoad() {
        Task {
            await fetchProducts()
        }
    }
    
    private func viewWillAppear() {
        Task {
            await getFavIDs()
        }
    }
    
    private func didSelectItem(_ index: Int) {
        let selectedProduct = products!.products[index]
        actions?.showProductDetails(selectedProduct)
    }
}

// MARK: - OUTPUT. View event methods -

extension DefaultMainViewModel {
    
}
