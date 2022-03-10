//
//  APIService.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import Foundation

enum APIType: String {
    case login = "/login"
    case register = "/register"
    case balance = "/balance"
    case transaction = "/transactions"
    case payees = "/payees"
    case transfer = "/transfer"
}

class APIService {
    
    static let shared = APIService()
    static let baseURL = "https://green-thumb-64168.uc.r.appspot.com"
    
    enum CustomError: Error {
        case invalidURL
        case invalidData
    }
    
    func postData<T: Codable>(apiType: APIType, httpBody: Data?, expecting: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: APIService.baseURL + apiType.rawValue) else {
            completionHandler(.failure(CustomError.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        if apiType == .transfer {
            urlRequest.setValue(UserDefaults.standard.string(forKey: "token"), forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.failure(CustomError.invalidData))
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(error))
            }
        }
        .resume()
    }
    
    func getData<T: Codable>(apiType: APIType, expecting: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: APIService.baseURL + apiType.rawValue) else {
            completionHandler(.failure(CustomError.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(UserDefaults.standard.string(forKey: "token"), forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(error))
            }
        }
        .resume()
    }
    
    static func formatAuthenticationBody(username: String, password: String) -> Data? {
        return "{\n    \"username\": \"\(username)\",\n    \"password\": \"\(password)\"\n}".data(using: .utf8)
    }
    
    static func formatTransferBody(receipientAccountNo: String, amount: Double, description: String) -> Data? {
        return "{\n    \"receipientAccountNo\": \"\(receipientAccountNo)\",\n    \"amount\": \(amount),\n    \"description\": \"\(description)\"\n}".data(using: .utf8)
    }
}
