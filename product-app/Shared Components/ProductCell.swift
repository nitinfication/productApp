//
//  ProductCell.swift
//  product-app
//
//  Created by Nitin Kumar on 02/06/24.
//

import SwiftUI

struct ProductCell: View {
    var imageURL: String
    var price: Double
    var productName: String
    var productType: String
    var tax: Double
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if !imageURL.isEmpty {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Image("loremPicsum")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(productType)
                        .font(.system(size: 16, weight: .regular))
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.green.opacity(0.1))
                        )
                    
                    Text(productName)
                        .font(.system(size: 20, weight: .regular))
                    
                    HStack {
                        Text(String(format: "₹%.2f", price))
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Text("Tax:")
                            .font(.system(size: 18, weight: .regular))
                        Text(String(format: "%.1f%%", tax))
                            .font(.system(size: 18, weight: .regular))
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.red.opacity(0.1))
                            )
                    }
                }
            }
            .padding(8)
//            Divider()
//                .padding(.vertical, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black.opacity(0.1), lineWidth: 1)
                .foregroundStyle(.clear)
        )
    }
}

#Preview {
    ProductCell(imageURL: "", price: 21, productName: "nfga", productType: "143", tax: 41)
}
