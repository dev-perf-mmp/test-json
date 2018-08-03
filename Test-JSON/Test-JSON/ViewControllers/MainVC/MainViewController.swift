//
//  TJMainViewController.swift
//  Test-JSON
//
//  Created by Midhun on 02/08/18.
//  Copyright © 2018 Midhun. All rights reserved.
//  Represents the main page
//

import UIKit

// MARK:- IBOutlets & Properties
class TJMainViewController: UIViewController
{
    // Tableview for showing the people
    @IBOutlet weak var tblPeople: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

