//
//  EntriesViewController.swift
//  Travelogue
//
//  Created by Dominic Pilla on 7/26/18.
//  Copyright © 2018 Dominic Pilla. All rights reserved.
//

import UIKit

class EntriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    var trip: Trip?
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let trip = trip {
            self.title = trip.title
        }
        
        dateFormatter.dateFormat = "MMM d, yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        entriesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.entries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        if let cell = cell as? EntryTableTableViewCell, let entry = trip?.entries?[indexPath.row] {
            cell.entryTitle.text = entry.title
            cell.entryImageView.image = entry.image
            if let date = entry.date {
                cell.entryDate.text = dateFormatter.string(from: date)
            }
        }
        
        return cell
    }
    
    func deleteEntry(at indexPath: IndexPath) {
        guard let entry = trip?.entries?[indexPath.row] else {
            return
        }
        
        if let managedObjectContext = entry.managedObjectContext {
            managedObjectContext.delete(entry)
            
            do {
                try managedObjectContext.save()
                entriesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                entriesTableView.reloadData()
            }
        }
    }
    
    // Delete Entry
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteEntry(at: indexPath)
        }
        
        return [delete]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        
        if segueIdentifier == "addEntry", let destination = segue.destination as? AddEntryViewController {
            destination.trip = trip
        } else if segueIdentifier == "displayEntry", let destination = segue.destination as? EntryViewController, let selectedRow = entriesTableView.indexPathForSelectedRow?.row {
            destination.trip = trip
            destination.entry = trip?.entries?[selectedRow]
        }
    }
}
