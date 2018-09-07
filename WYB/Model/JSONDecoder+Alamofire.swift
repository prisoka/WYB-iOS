//
//  JSONDecoder+Alamofire.swift
//  WYB
//
//  extension modified from : https://grokswift.com/decodable-with-alamofire-4/
//  credit: Grok Swift

import Foundation
import Alamofire

enum Decodererror: Error {
    case noData(String)
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(Decodererror.noData(
                "Did not get data in response"))
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}
