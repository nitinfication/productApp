//
//  ProductListView.swift
//  product-app
//
//  Created by Nitin Kumar on 02/06/24.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var showProductAddScreen = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.white.ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Products")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        Button(action: {
                            showProductAddScreen.toggle()
                        }) {
                            Text("+ Add Product")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(.black)
                                )
                        }
                    }
                    SearchBarView(placeholder: "search anything...", text: $searchText)
                    ScrollView(showsIndicators: false) {
                        if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else {
                            VStack {
                                ForEach(viewModel.filteredProducts, id: \.self) { product in
                                    ProductCell(
                                        imageURL: product.image ?? "",
                                        price: product.price,
                                        productName: product.productName,
                                        productType: product.productType,
                                        tax: product.tax
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .onAppear {
            viewModel.fetchProducts()
            viewModel.filterProducts(searchText: searchText)
            print("Total products: \(viewModel.products.count)")
        }
        .fullScreenCover(isPresented: $showProductAddScreen, content: {
            AddProductView()
        })
        .onChange(of: searchText) { newValue in
            viewModel.filterProducts(searchText: searchText)
        }
        .onChange(of: viewModel.filteredProducts) { _ in
            
        }
    }
}


#Preview {
    ProductListView()
}
