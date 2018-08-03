//
//  TJPersonTableViewCell.swift
//  Test-JSON
//
//  Created by Midhun on 03/08/18.
//  Copyright © 2018 Midhun. All rights reserved.
//  Represents the person cell
//

import UIKit

// MARK:- IBOutlets
class TJPersonTableViewCell: UITableViewCell
{
    // UIView for holding initial
    @IBOutlet weak var vwInitial: UIView!
    
    // Shows Initial Label
    @IBOutlet weak var lblInitial: UILabel!
    
    // Name of the User
    @IBOutlet weak var lblName: UILabel!
    
    // City name
    @IBOutlet weak var lblCity: UILabel!
}
