//
//  FavoriteViewModel.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 03/04/2023.
//

import Foundation
import Combine

struct FavoriteViewModelActions {
    let showProductDetails: (ProductEntity) -> Void
}

enum FavoriteListViewModelLoading {
    case nextPage
}

protocol FavoriteViewModelOutput {
    var products: ProductsPage? { get }
    var prices: String { get }
}

enum FavoriteVMInPut {
    case viewDidAppear
    case removeAllFavorites
}
enum FavoriteVMOutPut {
    case dataLoaded
}

protocol FavoriteViewModelInput {
}

protocol FavoriteViewModel: FavoriteViewModelOutput, ProductsViewModelInput {
    func transform(input: AnyPublisher<FavoriteVMInPut, Never>) -> AnyPublisher<FavoriteVMOutPut, Never>
}

final class DefaultFavoriteViewModel: FavoriteViewModel {
    
    //MARK: - Properties -
    
    private let fetchFavoriteProductsUseCase: FetchFavoriteProductsUseCase
    
    var products: ProductsPage?
    var prices: String = "0"
    private let output: PassthroughSubject<FavoriteVMOutPut, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init -
    
    init(fetchFavoriteProductsUseCase: FetchFavoriteProductsUseCase) {
        self.fetchFavoriteProductsUseCase = fetchFavoriteProductsUseCase
    }
    
    func transform(input: AnyPublisher<FavoriteVMInPut, Never>) -> AnyPublisher<FavoriteVMOutPut, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
                
            case .viewDidAppear:
                getFavorites()
                
            case .removeAllFavorites:
                removeAllFavorites()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func getFavorites() {
        Task {
            let favoriteProducts = await fetchFavoriteProductsUseCase.execute()
            products = favoriteProducts
            loadData()
        }
    }
    
    private func removeAllFavorites() {
        self.products?.products.removeAll()
        loadData()
        fetchFavoriteProductsUseCase.removeFavorites()
    }
    
    private func loadData() {
        output.send(.dataLoaded)
        prices = "Total: \(products?.products.map { $0.retailPrice }.reduce(0, +) ?? 0)"
    }
}
