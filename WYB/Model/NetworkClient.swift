//
//  NetworkClient.swift
//  WYB
//
//  Created by Priscilla Okawa on 2/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import Foundation
import Alamofire

// Struct: data structure that holds email and password.
// It's a req obj that holds the data I am sending in the http body to the server
// Codable: allows the obj to be transformed INTO JSON
struct LoginRequest: Codable {
    let email: String
    let password: String
    
    // the struct auto generates this initializer for you (kinda the same as contructor in JS):
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

// Struct: data structure that holds user's properties.
// It's a response obj that holds the data that I am receiveing from the server in the http response body
// Codable: allows the obj to be transformed FROM JSON
struct LoginResponse: Codable {
    let user_id: Int
    let first_name: String
    let user_type: UserType
}

struct NetworkResponseError: Codable {
    let error: NetworkErrorMessage
}

struct NetworkErrorMessage: Codable {
    let message: String
}

// handling cases for different user types (user/walker) for safety
enum UserType: String, Codable {
    case user
    case walker
}

struct WalkRequest: Codable {
    let userName: String
    let addressOne: String
    let addressTwo: String?
    let zip: Int
    let phoneNumber: String?
    let dogName: String
    let dogPhotoUrl: String?
    let id: Int
    let requestDate: Date
    let requestTimeString: String
    let startWalkDate: Date?
    var finishWalkDate: Date?
    let walkerId: Int?
    
    enum CodingKeys: String, CodingKey {
        case userName = "first_name"
        case addressOne = "address_one"
        case addressTwo = "address_two"
        case zip = "zip"
        case phoneNumber = "phone_number"
        case dogName = "dog_name"
        case dogPhotoUrl = "dog_photo_url"
        case id = "id"
        case requestDate = "request_date"
        case requestTimeString = "request_time"
        case startWalkDate = "start_walk_time"
        case finishWalkDate = "finish_walk_time"
        case walkerId = "walker_id"
    }
}

var userId: Int?

// create a class for handling all Network Req to the server
class NetworkClient {
    
    // storing the API URL in a constant
    let apiUrl = "https://wyb-api.herokuapp.com/api/"
    
    // func for sending http req to login end point, and hande response
    func login(email: String, password: String, completionBlock: @escaping (LoginResponse?, NetworkResponseError?) -> Void) {
        
        // storing the email and password in the LoginRequest obj
        let loginRequest = LoginRequest(email: email, password: password)
        
        // creating URL instance for the login end point using URL constructor
        if let loginUrl = URL(string: apiUrl + "login") {
            var urlRequest = URLRequest(url: loginUrl)
            urlRequest.httpMethod = "POST"
            
            let encoder = JSONEncoder()
            
            // encoding the loginRequest into JSON and assingning it to the req body
            urlRequest.httpBody = try? encoder.encode(loginRequest)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // getting the shared URL session, the one that actually dispatches URL reqs
            let urlSession = URLSession.shared
            
            // creating a task used to manage the req, e.g starting, cancelling.
            // passing in a closure (~function) as the completion block
            let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
                // if response is ok, or data ok, or error is nil -> continue (line 38)
                guard let response = response,
                    let data = data,
                    error == nil else {
                        // otherwise do else statement (lines 34-36)
                        // completionBlock(nil, error)
                        return
                }
                
                print(response)
                // decoding the data from JSON into login response obj
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let loginResponse = try? decoder.decode(LoginResponse.self, from: data)
                
                if let loginResponse = loginResponse {
                    userId = loginResponse.user_id
                    completionBlock(loginResponse, nil)
                } else {
                    let loginResponseError = try? decoder.decode(NetworkResponseError.self, from: data)
                    completionBlock(nil, loginResponseError)
                }
            }
            
            // starting URLRequest task
            dataTask.resume()
        }
    }
    
    func fetchAllRequests(completionBlock: @escaping ([WalkRequest]?, Error?) -> Void) {
        Alamofire.request(apiUrl+"requests", method: .get, headers: nil).responseData { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            let decodedResponse: Result<[WalkRequest]> = decoder.decodeResponse(from: response)

            switch decodedResponse {
                case .success(let walkRequests):
                    print("JSON: \(walkRequests)")
                    completionBlock(walkRequests, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionBlock(nil, error)
            }
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    func fetchOneRequest(requestId: Int, completionBlock: @escaping ([WalkRequest]?, Error?) -> Void) {
        Alamofire.request(apiUrl+"requests/"+"\(requestId)", method: .get, headers: nil).responseData { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            let decodedResponse: Result<[WalkRequest]> = decoder.decodeResponse(from: response)
            
            switch decodedResponse {
            case .success(let walkRequest):
                print("JSON: \(walkRequest)")
                completionBlock(walkRequest, nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionBlock(nil, error)
            }
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    func updateOneRequest(request: WalkRequest, completionBlock: @escaping (WalkRequest?, Error?) -> Void) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try? encoder.encode(request)
        
        if let url = URL(string: apiUrl+"requests/"+"\(request.id)") {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.put.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            Alamofire.request(request).responseData { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let decodedResponse: Result<WalkRequest> = decoder.decodeResponse(from: response)
                
                switch decodedResponse {
                case .success(let walkRequest):
                    print("JSON: \(walkRequest)")
                    completionBlock(walkRequest, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionBlock(nil, error)
                }
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        }
    }
}
