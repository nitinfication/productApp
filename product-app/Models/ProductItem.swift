//
//  ProductItem.swift
//  product-app
//
//  Created by Nitin Kumar on 02/06/24.
//

import Foundation
import UIKit

struct ProductType : Codable,Hashable {
    let image : String?
    let productName: String
    let productType: String
    let price: Double
    let tax: Double
}


struct NewProductType : Codable,Hashable {
    let image : Data?
    let productName: String
    let productType: String
    let price: Double
    let tax: Double
}
