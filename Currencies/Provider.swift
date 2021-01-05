//
//  Provider.swift
//  Currencies
//
//  Created by Anton Levin on 29.11.2020.
//

import UIKit

enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

class Provider {
    
    func getData(callback: @escaping (Result<[Currency], Error>) -> ()) {
        let urlString = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
        guard let url = URL(string: urlString ) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                callback(.failure(error))
            }
            guard let currencyData = data else {
                callback(.success([]))
                return
            }
            do {
                UserDefaultsStorage.saveObjectWith(currencyData, key: "course")
                let course = try JSONDecoder().decode([Currency].self, from: currencyData)
                callback(.success(course))
            }
            catch {
                print("Error JSON data")
                callback(.success([]))
            }
        }.resume()
    }
}

class UserDefaultsStorage {
    
    class func saveObjectWith(_ model: Codable, key: String) {
        UserDefaults.standard.set(model, forKey: key)
    }
    
    class func fetchObjectWith<T: Codable>(_ type: T.Type, key: String) throws -> T? {
        guard let currencyData = UserDefaults.standard.data(forKey: key) else { return nil }
        return try JSONDecoder().decode(type, from: currencyData)
    }
    
}
