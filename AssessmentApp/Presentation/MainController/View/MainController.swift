//
//  MainController.swift
//  AssessmentApp
//
//  Created by Irfan Saeed on 19/01/2022.
//

import UIKit
import Combine

class TableViewAdjustedHeight: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}

class MainController: UIViewController {
    
    
    //MARK: - Properties -
    
    private var viewModel: MainControllerViewModel!
    private let input: PassthroughSubject<InPut, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - IBOutlets -
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - ViewLifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()

        setupUI()
        input.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewWillAppear)
    }
    
    //MARK: - Create -
    
    /// Function to init and load xib ViewController file of the MainController with the required dependencies
    /// - Parameter viewModel: The view Model abstraction dependency type
    /// - Returns: MainController intialized and injected with required dependencies
    static func create(with viewModel: MainControllerViewModel) -> MainController {
        let vc = MainController.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    
    //MARK: - Private functions -
    
    private func setupUI() {
        registerTableView()
        navBarButton()
    }
    
    private func registerTableView() {
        tableView.delegate = self
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
            }
      }.store(in: &cancellables)
      
    }
    
    private func navBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoritePressed))
    }
    
    @objc private func favoritePressed() {
        input.send(.presentFavorites)
    }
}

//MARK: - UITableViewDataSource -

extension MainController: UITableViewDataSource {
    
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
                       favouritAction: {
            self.input.send(.saveAsFavorite(index: indexPath.row))
        })
        return cell
    }
    
}

//MARK: - UITableViewDelegate -

extension MainController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        input.send(.didSelectItem(index: indexPath.row))
    }
    
}
