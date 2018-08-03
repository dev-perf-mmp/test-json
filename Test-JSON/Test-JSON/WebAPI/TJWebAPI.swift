//
//  TJWebAPI.swift
//  Test-JSON
//
//  Created by Midhun on 03/08/18.
//  Copyright © 2018 Midhun. All rights reserved.
//  Represents the Web API
//

import UIKit

// Completion Handler for passing the result back
typealias WebAPICompletionHandler = (Bool, Data?, Error?) -> (Void)

// MARK:- Properties and initializers
class TJWebAPI: NSObject
{
    // Singleton instance of the API
    static let shared = TJWebAPI()
    
    // URL session object for calling web-services
    fileprivate var urlSession : URLSession
    
    // Default initializers
    override init()
    {
        // Configuring NSURLSession
        let urlSessionConfig                           = URLSessionConfiguration.default
        urlSessionConfig.timeoutIntervalForRequest     = 30.0
        urlSessionConfig.httpMaximumConnectionsPerHost = 3
        urlSessionConfig.requestCachePolicy            = .reloadIgnoringLocalAndRemoteCacheData
        
        urlSession = URLSession(configuration: urlSessionConfig)
        
        super.init()
    }
}

// MARK:- GET methods
extension TJWebAPI
{
    /// Retrieves the details of person from server
    ///
    /// - Parameter completion: Closure that will be invoked when a result is returned from server
    func getPersonDetails(completion: @escaping WebAPICompletionHandler)
    {
        let url            = TJWebURL.person.url
        var request        = URLRequest(url: url)
        request.httpMethod = "GET"
        request            = setCommonHTTPHeaders(request: request)
        callAsynchronousWebService(withRequest: request, andCompletionHandler: completion)
    }
}

// MARK:- Private methods
extension TJWebAPI
{
    
    /// Makes asynchronous API calls
    /// - parameter request:           Request that need to be made
    /// - parameter completionHandler: Closure that will be invoked when a result is returned from server
    fileprivate func callAsynchronousWebService(withRequest request : URLRequest, showIndicator show : Bool = true, andCompletionHandler completionHandler : WebAPICompletionHandler?)
    {
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if let completionHandler = completionHandler
            {
                let httpResponse = response as? HTTPURLResponse
                let success      = httpResponse != nil ? (httpResponse!.statusCode >= 200 && httpResponse!.statusCode < 300) : false
                DispatchQueue.main.async
                    {
                        completionHandler(success, data, error)
                }
            }
            
        }
        dataTask.resume()
    }
    
    /// Appends common http headers to the project
    /// - parameter request: URL request to which the common header need to be added
    /// - returns: Changed request object
    fileprivate func setCommonHTTPHeaders(request : URLRequest) -> URLRequest
    {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
