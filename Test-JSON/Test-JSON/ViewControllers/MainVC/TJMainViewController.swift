//
//  TJMainViewController.swift
//  Test-JSON
//
//  Created by Midhun on 02/08/18.
//  Copyright © 2018 Midhun. All rights reserved.
//  Represents the main page
//

import UIKit
import Reachability
import NVActivityIndicatorView

// MARK:- IBOutlets & Properties
class TJMainViewController: UIViewController
{
    // MARK: IBOutlets
    // Tableview for showing the people
    @IBOutlet weak var tblPeople: UITableView!
    
    // MARK: Properties
    
    // Person data
    var persons: [TJPerson]?
    
    // Reachability
    fileprivate let reachability = Reachability()
    
}

// MARK:- Lifecycle Methods
extension TJMainViewController
{
    // View Did Load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Monitors network
        monitorNetwork()
        
        // Set tableview datasource
        tblPeople.dataSource = self
    }
}

// MARK;- UITableViewDataSource
extension TJMainViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if (persons?.count ?? 0) > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return persons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: TJConstants.CellIdentifiers.personCell) as! TJPersonTableViewCell
        let person                     = persons![indexPath.row]
        cell.lblName.text              = person.fullName
        cell.lblCity.text              = person.city
        cell.lblInitial.text           = person.shortName
        cell.vwInitial.backgroundColor = person.getRandomColor()
        return cell
    }
}

// MARK:- API interaction
extension TJMainViewController
{
    // Get Person Data
    func getPersonData()
    {
        let loadingView = self.showLoading()
        TJWebAPI.shared.getPersonDetails { (isSuccess, data, error) -> (Void) in
            self.hideLoading(viewLoading: loadingView)
            
            // Checking Status of API Call
            if isSuccess && data != nil
            {
                if let data = data, let persons = try? JSONDecoder().decode([TJPerson].self, from: data)
                {
                    self.persons = persons
                    self.tblPeople.reloadData()
                }
            }
        }
    }
}

// MARK:- Network related
extension TJMainViewController
{
    /// Monitors the network status
    func monitorNetwork()
    {
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async
            {
                self.hideMessages()
                if let personData = self.persons, personData.count > 0
                {
                    self.showInfoMessage(withTitle: TJConstants.Messages.netSuccessTitle, andMessage: TJConstants.Messages.netSuccessMsg)
                }
                else
                {
                    self.getPersonData()
                }
            }
        }
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async
            {
                self.showErrorMessage(withTitle: TJConstants.Messages.netErrorTitle, andMessage: TJConstants.Messages.netErrorMsg)
            }
        }
        
        // Starting notifier
        do
        {
            try reachability?.startNotifier()
        }
        catch
        {
            print("Unable to start notifier")
        }
    }
}
