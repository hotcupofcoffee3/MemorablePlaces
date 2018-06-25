//
//  MapViewController.swift
//  MemorablePlaces
//
//  Created by Adam Moore on 4/20/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// Also had to add the two initial privacy location items in the plist file.

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let uilpr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(gestureRecognizer:)))
        
        uilpr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpr)
        
        if indexSelected == -1 {
        
            // If just the "+" button pressed, this gets the users location.
            // Had to add "CLLocationManagerDelegate" at the top, and create an instance of "CLLocationManager()", which we assigned to "manager".
            // Also added "didUpdateLocations" function below for the "locationManager()" function.
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        
        } else {

            if let name = places[indexSelected]["name"] {
                
                if let lat = places[indexSelected]["lat"] {
                    
                    if let lon = places[indexSelected]["lon"] {
                        
                        if let latitude = Double(lat) {
                            
                            if let longitude = Double(lon) {
                                
                                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                
                                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                
                                let region = MKCoordinateRegion(center: location, span: span)
                                
                                self.map.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                
                                annotation.coordinate = location
                                
                                annotation.title = name
                                
                                self.map.addAnnotation(annotation)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
       
    }
    
    @objc func longpress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        // Only does it once, even if it is held down for longer.
        // If this isn't done, then it'll keep adding a new one of these every 2 seconds (the amount of time we have it set).
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecognizer.location(in: self.map)
            
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var title = "Anus"
            
            var num = 1
            
            // This is not working. It gets to the subthoroughfare part, but it never changes the title in any way
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare! + " "
                            
                        }
                        
                        if placemark.thoroughfare != nil {

                            title += placemark.thoroughfare!
                            
                            num = 5
                        }
                        
                    } 
                    
                }
                
                if title == "" {
                    
                    title = "Added a new place"
                    
                }
                
            })
            
            print(title)
            
            print(num)
            
            print("Fart")
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = newCoordinate
            
            annotation.title = title
            
            map.addAnnotation(annotation)
            
            let latitude = newCoordinate.latitude
            let longitude = newCoordinate.longitude
            
            print(latitude)
            print(longitude)
            
            places.append(["name": title, "lat": String(latitude), "lon": String(longitude)])
                
            UserDefaults.standard.set(places, forKey: "Memorable Places")
            
            print("long press")
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}









