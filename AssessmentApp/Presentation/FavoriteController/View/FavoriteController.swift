//
//  FavoriteController.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 03/04/2023.
//

import UIKit
import Combine

class FavoriteController: UIViewController {
    
    //MARK: - IBOutlets -
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var priceLbl: UILabel!
    
    //MARK: - Properties -
    
    private var viewModel: FavoriteViewModel!
    private let input: PassthroughSubject<FavoriteVMInPut, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    
    //MARK: - Create -
    
    static func create(with viewModel: FavoriteViewModel) -> FavoriteController {
       let vc = FavoriteController.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewDidAppear)
    }
    
    //MARK: - IBActios -
    
    @IBAction private func emptyPressed(_ sender: Any) {
        input.send(.removeAllFavorites)
    }
    
    @IBAction private func dismissPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Private functions -
    
    private func setupUI() {
        registerTableView()
    }
    
    private func registerTableView() {
        tableView.dataSource = self
        let nib = UINib(nibName: ProductCell.xibName, bundle: nil)
        tableView.register(nib,
                           forCellReuseIdentifier: ProductCell.reusableIdentifier)
    }
    
    private func bind() {
      let output = viewModel.transform(input: input.eraseToAnyPublisher())
      output
        .receive(on: DispatchQueue.main)
        .sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .dataLoaded:
                tableView.reloadData()
                priceLbl.text = viewModel.prices
            }
      }.store(in: &cancellables)
      
    }
    
}

//MARK: - UITableViewDataSource -

extension FavoriteController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                viewModel.products?.products.count ?? 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductCell.reusableIdentifier,
            for: indexPath)
                as? ProductCell else {
            fatalError("Couldn't dequeue \(ProductCell.self)")
        }
        guard let product = (viewModel.products?.products[indexPath.row]) else { return UITableViewCell() }
                cell.configure(product: product,
                               hiddenFavBtn: true)
        return cell
    }
    
}

