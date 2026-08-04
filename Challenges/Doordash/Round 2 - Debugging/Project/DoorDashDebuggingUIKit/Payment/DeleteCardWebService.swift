//
//  DeleteCardWebService.swift
//  DoorDashDebuggingUIKit
//
//  Created by Mike Zaslavskiy on 8/27/24.
//

import Foundation
import Combine

protocol DeleteCardWebService {
    func deletePaymentMethod(withId id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

extension NetworkService: DeleteCardWebService {}

extension DeleteCardWebService where Self: URLLoading {
    func deletePaymentMethod(withId id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "www.doordash.com/deletePaymentMethod?id=\(id)")!)
        request.httpMethod = "DELETE"
        
        process(request) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
