//
//  NetworkService.swift
//  product-app
//
//  Created by Nitin Kumar on 02/06/24.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    func fetchProducts(completion: @escaping (Result<[ProductType], Error>) -> Void) {
        guard let url = URL(string: Bundle.main.infoDictionary?["GET_API_KEY"]  as? String ?? "") else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedProducts = try decoder.decode([ProductType].self, from: data)
                completion(.success(decodedProducts))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func postCall(productType: NewProductType) async {
        let urlString = "https://app.getswipe.in/api/public/add"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        let boundary = UUID().uuidString
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        let parameters = [
            "product_name": productType.productName,
            "product_type": productType.productType,
            "price": "\(productType.price)",
            "tax": "\(productType.tax)"
        ]
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let imageData = productType.image {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                return
            }
            
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Response: \(jsonResponse)")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
