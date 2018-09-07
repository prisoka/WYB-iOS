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

struct LoginResponseError: Codable {
    let error: LoginErrorMessage
}

struct LoginErrorMessage: Codable {
    let message: String
}

// handling cases for different user types (user/walker) for safety
enum UserType: String, Codable {
    case user
    case walker
}

// create a class for handling all Network Req to the server
class NetworkClient {
    // storing the API URL in a constant
    let apiUrl = "https://wyb-api.herokuapp.com/api/"
    
    // func for sending http req to login end point, and hande response
    func login(email: String, password: String, completionBlock: @escaping (LoginResponse?, LoginResponseError?) -> Void) {
        
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
                let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
                
                if let loginResponse = loginResponse {
                    completionBlock(loginResponse, nil)
                } else {
                    let loginResponseError = try? JSONDecoder().decode(LoginResponseError.self, from: data)
                    completionBlock(nil, loginResponseError)
                }
            }
            
            // starting URLRequest task
            dataTask.resume()
        }
    }
    
    func fetchAllRequests() {
        
    }
}
