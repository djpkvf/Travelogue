//
//  TripsViewController.swift
//  Travelogue
//
//  Created by Dominic Pilla on 7/23/18.
//  Copyright © 2018 Dominic Pilla. All rights reserved.
//

import UIKit
import CoreData

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTrips()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        if let cell = cell as? TripTableViewCell {
            let trip = trips[indexPath.row]
            
            cell.tripTitleLabel.text = trip.title
            cell.tripDescriptionLabel.text = trip.contents
        }
        
        return cell
    }
    
    // Delete or Edit Trip
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.confirmDeleteTrip(at: indexPath)
        }
        
        return [delete]
    }
    
    func confirmDeleteTrip(at indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        
        if let entries = trip.entries, entries.count > 0 {
            let title = trip.title ?? "Trip"
            // Alert user to delete the Trip if the Trip contains any Entries
            let alert = UIAlertController(title: "Delete Trip", message: "\(title) contains entries. Do you want to delete it?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {
                (alertAction) -> Void in
                self.deleteTrip(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            deleteTrip(at: indexPath)
        }
    }
    
    func deleteTrip(at indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        
        if let managedObjectContext = trip.managedObjectContext {
            managedObjectContext.delete(trip)
            
            do {
                try managedObjectContext.save()
                self.trips.remove(at: indexPath.row)
                tripsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Deletion of Trip Failed")
                tripsTableView.reloadData()
            }
        }
    }
    
    func getTrips() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            trips = try managedContext.fetch(fetchRequest)
            
            tripsTableView.reloadData()
        } catch {
            print("Could not fetch")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EntriesViewController,
            let selectedRow = self.tripsTableView.indexPathForSelectedRow?.row else {
                return
        }
        destination.trip = trips[selectedRow]
    }
}
