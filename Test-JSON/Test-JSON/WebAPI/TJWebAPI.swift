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
        
    }
    
    
    /// API for registering push token
    /// - parameter credentials: Credentials for registering push
    /// - parameter completion:  Closure that will be invoked when a result is returned from server
    func registerPush(withCredentials credentials : Dictionary<String, String>, completion : @escaping WebAPICompletionHandler)
    {
        let url            = appendHostName(urlPrefix: "notifications/create")
        var request        = URLRequest(url: url)
        let postData       = dataFromJSON(json: credentials)
        request.httpMethod = "POST"
        request            = setCommonHTTPHeaders(request: request)
        request.httpBody   = postData
        callAsynchronousWebService(withRequest: request, andCompletionHandler: completion)
    }
}

// MARK:- Private methods
extension EPWebAPI
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
    
    /// Appends the url prefix to host name and returns the combined url
    /// - parameter urlPrefix: URL prefix that need to be appended to host name
    /// - returns: URL of combined host and prefix
    fileprivate func appendHostName(urlPrefix : String) -> URL
    {
        var config = Configuration()
        let host   = config.environment.api
        var urlStr = host + urlPrefix
        urlStr     = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return URL(string: urlStr)!
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
