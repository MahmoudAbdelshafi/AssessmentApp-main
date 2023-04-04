//
//  DetailController.swift
//  AssessmentApp
//
//  Created by Mahmoud Abdelshafi on 03/04/2023.
//

import UIKit

class DetailController: UIViewController {
    
    //MARK: - IBOutlets -
    
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var descriptionLbl: UILabel!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var productImg: UIImageView!
    
    //MARK: - Properties -
    
    private var detailsData: ProductEntity!
    
    //MARK: - Create -
    
    static func create(detailsData: ProductEntity) -> DetailController {
        let vc = DetailController.loadFromNib()
        vc.detailsData = detailsData
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillData()
    }
  
    private func fillData() {
        self.productImg.loadWebImageWithUrl(imageUrl: detailsData.imageURL)
        self.titleLbl.text = detailsData.name
        self.descriptionLbl.text = detailsData.description
        self.priceLbl.text = "Price: \(detailsData.retailPrice) LE"
    }
    
}
