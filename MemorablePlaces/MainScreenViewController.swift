//
//  MainScreenViewController.swift
//  MemorablePlaces
//
//  Created by Adam Moore on 4/20/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

var places = [[String: String]]()
var indexSelected = -1

class MainScreenViewController: UITableViewController {
    
    func loadSavedPlaces() {
        
        if let savedPlaces = UserDefaults.standard.object(forKey: "Memorable Places") as? [[String: String]] {
            
            places = savedPlaces
            
        } else {
            
            if places.count == 0 {
                
                places.append([
                    "name": "Taj Mahal",
                    "lat": "27.175277",
                    "lon": "78.042128"
                    ])
                
            }
            
        }
        
    }
    
    func savePlaces() {
        
        UserDefaults.standard.set(places, forKey: "Memorable Places")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedPlaces()
        placesTable.reloadData()
        indexSelected = -1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadSavedPlaces()
        placesTable.reloadData()
        indexSelected = -1
        
        for place in places {
            
            print(place["name"]!)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var placesTable: UITableView!
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        if places[indexPath.row]["name"] != nil {
            
            cell.textLabel?.text = places[indexPath.row]["name"]
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToMap", sender: self)
        indexSelected = indexPath.row
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            places.remove(at: indexPath.row)
            savePlaces()
            placesTable.reloadData()
            
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
