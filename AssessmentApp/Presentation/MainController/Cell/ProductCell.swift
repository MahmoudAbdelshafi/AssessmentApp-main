//
//  ProductCell.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 02/04/2023.
//

import UIKit

class ProductCell: UITableViewCell {
    
    //MARK: - Properties -
    
    static let reusableIdentifier = String(describing: ProductCell.self)
    static let xibName = String(describing: ProductCell.self)
    private var favouritAction: (() -> ())?
    private var isFavBtnHidden = false

    //MARK: - IBOutlets -
    
    @IBOutlet weak private var productImg: UIImageView!
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var descriptionLbl: UILabel!
    @IBOutlet weak private var priceLbl: UILabel!
    @IBOutlet weak private var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(product: ProductEntity, hiddenFavBtn: Bool? = nil, favouritAction: (() -> ())? = nil) {
        setupUI(hiddenFavBtn, isFav: product.isFavorite)
        productImg.loadWebImageWithUrl(imageUrl: product.imageURL)
        nameLbl.text = product.name
        descriptionLbl.text = product.description
        priceLbl.text = "\(product.retailPrice) LE"
        self.favouritAction = favouritAction
    }
    
    private func setupUI(_ hiddenFavBtn: Bool? = nil, isFav: Bool) {
        favButton.isHidden = isFav
        if let hiddenFavBtn {
            favButton.isHidden = hiddenFavBtn
        }
    }
    
    @IBAction private func favPressed(_ sender: UIButton) {
        favouritAction?()
        isFavBtnHidden = true
        sender.isHidden = true
    }
    
}
