//
//  TJPerson.swift
//  Test-JSON
//
//  Created by Midhun on 03/08/18.
//  Copyright © 2018 Midhun. All rights reserved.
//  Represents the person model
//

import UIKit

// MARK:- Properties
struct TJPerson: Codable
{
    // First Name
    var fname: String?
    
    // Last Name
    var lname: String?
    
    // City
    var city: String?
    
    // Full Name
    var fullName: String?
    {
        var fullName = ""
        // First Name
        if let fName = fname?.capitalized
        {
            fullName += fName + " "
        }
        // Appending Last Name
        if let lName = lname?.capitalized
        {
            fullName += lName
        }
        return fullName
    }
    
    // Short name
    var shortName: String?
    {
        var shortLabel = ""
        
        // Firstname Short Literal
        if let fLabel = fname?.first
        {
            shortLabel += String(fLabel)
        }
        else if let lLabel = lname?.first
        {
            // Last name Short Literal
            shortLabel += String(lLabel)
        }
        return shortLabel
    }
    
    // Returns a random color for the name
    func getRandomColor() -> UIColor
    {
        let randomRed   = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue  = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}
