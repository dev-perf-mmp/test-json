//
//  TJWebAPIContstants.swift
//  Test-JSON
//
//  Created by Midhun on 03/08/18.
//  Copyright © 2018 Midhun. All rights reserved.
//  Represents the Web API Constants
//

import UIKit

// MARK:- API

/// API URLS
///
/// - local: Local URL
/// - development: Development URL
/// - staging: Staging URL
/// - production: Production URL
enum TJAPI : String
{
    case local       = "local url"
    case development = "http://www.filltext.com"
    case staging     = "staging url"
    case production  = "production url"
}

// MARK:- API URLs
enum TJWebURL
{
    // Person URL
    case person
}

// Extension for URL creation
extension TJWebURL
{
    
    /// Returns the URL
    var url: URL
    {
        // Base URL
        let baseURL   = TJAPI.development.rawValue
        
        // Stores the combined url which will be returned
        var returnURL = ""
        switch self
        {
        case .person: returnURL = baseURL + "?fname={firstName}&lname={lastName}&city={city}&pretty=true"
        }
        // Escapes the URL
        let escapedURLString = returnURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)?.replacingOccurrences(of: "+", with: "%2B")
        return URL(string: escapedURLString!)!
    }
}
