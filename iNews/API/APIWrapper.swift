//
//  APIWrapper.swift
//  iNews
//
//  Created by Ashish Bansal on 12/10/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import Foundation
import AWSAPIGateway
import AWSMobileClient
import Result

enum APIError: Error {
    case apiError
}

class APIWrapper {
    
    static let sharedInstance = APIWrapper()
    
    private init() {}
    
    func getNewsList(completion: @escaping (Result<NewsResult, APIError>) -> Void) {
        let httpMethodName = "GET"
        let URLString = "/getNewsList"
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: nil,
                                              headerParameters: headerParameters,
                                              httpBody: nil)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast2,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_5D8XSKEEN7_GetNewsListClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient = AWSAPI_5D8XSKEEN7_GetNewsListClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                completion(Result(error: APIError.apiError))
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: .utf8)!
            let newsResponse = try! NewsResult(JSONString: responseString)
            completion(Result(value: newsResponse))
            return nil
        }
    }
    
    func getNewsByID(newsID: String, completion: @escaping (Result<NewsDetail, APIError>) -> Void) {
        let httpMethodName = "GET"
        let URLString = "/getnewsbyid"
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let queryParams = ["id": newsID]
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryParams,
                                              headerParameters: headerParameters,
                                              httpBody: nil)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast2,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_5D8XSKEEN7_GetNewsListClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient = AWSAPI_5D8XSKEEN7_GetNewsListClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                completion(Result(error: APIError.apiError))
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: .utf8)!
            let newsResponse = try! NewsDetail(JSONString: responseString)
            completion(Result(value: newsResponse))
            return nil
        }
    }
    
    func search(string: String, completion: @escaping (Result<NewsResult, APIError>) -> Void) {
        let httpMethodName = "GET"
        let URLString = "/searchNews"
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let queryParams = ["searchKey": string]
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryParams,
                                              headerParameters: headerParameters,
                                              httpBody: nil)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast2,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_5D8XSKEEN7_GetNewsListClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient = AWSAPI_5D8XSKEEN7_GetNewsListClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                completion(Result(error: APIError.apiError))
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: .utf8)!
            let newsResponse = try! NewsResult(JSONString: responseString)
            completion(Result(value: newsResponse))
            return nil
        }
    }
}
