//
//  AddProductView.swift
//  product-app
//
//  Created by Nitin Kumar on 02/06/24.
//

import SwiftUI

struct AddProductView: View {
    @State private var price: String = ""
    @State private var productName: String = ""
    @State private var tax: String = ""
    @State private var selectedProduct = products[0]
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImages: UIImage? = nil
    @State private var isImagePickerPresented = false
    
    @StateObject private var viewModel = ProductViewModel()
    
    @State private var isShowingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Add a new Product")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
                BackButton()
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 32)
            HStack {
                Text("Product Type")
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Picker("Select a Product", selection: $selectedProduct) {
                    ForEach(products, id: \.self) { product in
                        Text(product)
                            .foregroundColor(.black)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal, 32)
            
            FloatingPlaceholderTextField(text: $productName, placeholder: "Book", fieldHeading: "Product Name", characterLimit: 50, keyboardType: .alphabet)
            
            HStack {
                FloatingPlaceholderTextField(text: $price, placeholder: "₹19.99", fieldHeading: "Price", characterLimit: 12, keyboardType: .numbersAndPunctuation)
                FloatingPlaceholderTextField(text: $tax, placeholder: "15%", fieldHeading: "Tax", characterLimit: 8, keyboardType: .numbersAndPunctuation)
            }
            
            Text("Product Image")
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(.black.opacity(0.5))
                .padding(.horizontal, 32)
                .padding(.vertical, 4)
            
            ZStack {
                if let image = selectedImages {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .onTapGesture {
                            isImagePickerPresented = true
                        }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.black.opacity(0.1), lineWidth: 1)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 34, height: 34)
                            .foregroundStyle(.black.opacity(0.5))
                            .cornerRadius(8)
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImages)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            RoundedButton(title: "Add Product", action: {
                if validateInputs() {
                    let newProduct = NewProductType(image: selectedImages?.pngData(),
                                                    productName: productName,
                                                    productType: selectedProduct,
                                                    price: Double(price) ?? 0.0,
                                                    tax: Double(tax) ?? 0.0)
                    Task {
                        await viewModel.postProduct(product: newProduct)
                        await viewModel.fetchProducts()
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    isShowingAlert = true
                }
            }, color: .black, textColor: .white)
            
            .padding(.horizontal, 32)
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $viewModel.showSuccessAlert) {
                Alert(
                    title: Text("Message"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                        
                    })
                )
            }
            
        }
    }
    
    private func validateInputs() -> Bool {
        var isValid = true
        
        if let _ = Double(tax.replacingOccurrences(of: "%", with: "")) {
            // Valid tax
        } else {
            alertTitle = "Invalid Tax"
            alertMessage = "Please enter a valid tax percentage."
            isValid = false
        }
        
        if let _ = Double(price) {
            // Valid price
        } else {
            alertTitle = "Invalid Price"
            alertMessage = "Please enter a valid price."
            isValid = false
        }
        
        if productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertTitle = "Invalid Product Name"
            alertMessage = "Please enter a valid product name."
            isValid = false
        }
        
        return isValid
    }
    
    func convertImageToBase64(_ image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 0.1) {
            return imageData.base64EncodedString()
        }
        return nil
    }
}


#Preview {
    AddProductView()
}
