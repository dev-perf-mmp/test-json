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
    fileprivate var contactsData: [String: [TJPerson]]?
    
    // Section Titles
    fileprivate var sectionTitles: [String]?
    
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
        if (sectionTitles?.count ?? 0) > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = (sectionTitles?.count ?? 0)
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
        let contacts = contactsData![sectionTitles![section]]
        return contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: TJConstants.CellIdentifiers.personCell) as! TJPersonTableViewCell
        let person                     = contactsData![sectionTitles![indexPath.section]]![indexPath.row]
        cell.lblName.text              = person.fullName
        cell.lblCity.text              = person.city
        cell.lblInitial.text           = person.shortName
        cell.vwInitial.backgroundColor = person.getRandomColor()
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return sectionTitles
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
                    let contacts = persons
                    self.sortContacts(contacts)
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
                if let personData = self.sectionTitles, personData.count > 0
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

// MARK:- Utility
extension TJMainViewController
{
    
    /// Sorts the contacts
    ///
    /// - Parameter contactsArray: Contacts array
    func sortContacts(_ contactsArray: [TJPerson])
    {
        var contacts = contactsArray
        contacts.sort(by: { (first, second) -> Bool in
            return first.fullName! < second.fullName!
        })
        generateIndexTitles(forContacts: contacts)
    }
    
    
    /// Generates the index titles
    ///
    /// - Parameter forContacts: Contacts array
    func generateIndexTitles(forContacts contacts: [TJPerson])
    {
        contactsData         = [String: [TJPerson]]()
        sectionTitles        = [String]()
        
        // Loops through tht items
        for item in contacts
        {
            if let firstCharacter = item.fullName?.first
            {
                // Creating the index title
                let firstLetter  = String(firstCharacter)
                
                // Storing contacts in corresponding section
                var contactArray = contactsData![firstLetter] ?? [TJPerson]()
                contactArray.append(item)
                contactsData![firstLetter] = contactArray
                
                // Storing the section title
                if !sectionTitles!.contains(firstLetter)
                {
                    sectionTitles?.append(firstLetter)
                }
            }
        }
        tblPeople.reloadData()
    }
}
