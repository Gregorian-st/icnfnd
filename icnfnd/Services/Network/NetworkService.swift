//
//  NetworkService.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import Foundation

struct IconServerError: Error {
    
    var code: String
    var message: String
}

final class NetworkService {
    
    private let cache = NetworkCache()
    private let authKey = "X0vjEUN6KRlxbp2DoUkyHeM0VOmxY91rA6BbU5j3Xu6wDodwS0McmilLPBWDUcJ1" // Put your Auth Key here
    
    func fetchIcons(searchText: String, completion: @escaping (Result<Icons, IconServerError>) -> Void) {
     
        if let iconsResult = cache[searchText] {
            completion(.success(iconsResult.icons))
            return
        }
        
        let parameters: [String: Any] = [
            "query": searchText,
            "count": 100,
            "vector": "false",
            "premium": "false"
        ]
        guard let parametersString = parameters.percentEncoded(),
              let url = URL(string: "https://api.iconfinder.com/v4/icons/search?" + parametersString)
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(authKey)",
                         forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(IconServerError(code: "URLSession Error", message: error.localizedDescription)))
                return
            }
            
            do {
                guard let data = data
                else {
                    completion(.failure(IconServerError(code: "Data Error", message: "No Data")))
                    return
                }
                
                let iconsResult = try JSONDecoder().decode(IconsResult.self, from: data)
                if let code = iconsResult.code {
                    let message = iconsResult.message ?? ""
                    completion(.failure(IconServerError(code: code, message: message)))
                    return
                }
                self?.cache[searchText] = iconsResult
                completion(.success(iconsResult.icons))
            } catch {
                completion(.failure(IconServerError(code: "Data Error", message: "Parsing error")))
            }
        }.resume()
    }
}
