//
//  ProductListingAPI.swift
//  product-app
//
//  Created by Nitin Kumar on 02/06/24.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [ProductType] = []
    @Published var errorMessage: String?
    @Published var filteredProducts: [ProductType] = []
    @Published var showSuccessAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func fetchProducts() {
        NetworkService.shared.fetchProducts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    print("Fetched \(products.count) products")
                    print("Fetched \(products.first)")
                    self.products = products
                    self.filteredProducts = products
                case .failure(let error):
                    print("Error fetching products: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func postProduct(product: NewProductType) async {
        do {
            await NetworkService.shared.postCall(productType: product)
            DispatchQueue.main.async {
                self.showSuccessAlert = true
                self.alertMessage = "Successfully added the new product item"
                self.fetchProducts()
            }
        } catch {
            DispatchQueue.main.async {
                self.showSuccessAlert = true
                self.alertMessage = "Error adding this product listing to the catalogue: \(error.localizedDescription)"
            }
        }
    }
    
    func filterProducts(searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
        }
        self.objectWillChange.send()
    }
}


