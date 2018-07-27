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
    
    // Selecting image from Photo Library
//    @IBAction func addImageFromPicker(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.allowsEditing = true
//        picker.delegate = self
//        present(picker, animated: true)
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
//        
//        imageView.image = image
//
//        dismiss(animated: true)
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EntriesViewController,
            let selectedRow = self.tripsTableView.indexPathForSelectedRow?.row else {
                return
        }
        destination.trip = trips[selectedRow]
    }
}
