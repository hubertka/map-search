//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Hubert Ka on 2018-01-18.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class ViewController: UIViewController {
    
    //MARK: Properties
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow view controller to act as location manager delegate
        locationManager.delegate = self
        
        // Override default accuracy level to highest level.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Trigger location permission dialog.
        locationManager.requestWhenInUseAuthorization()
        
        // Triggers a one time location request at load time.
        locationManager.requestLocation()
        
        /* SEARCH BAR AND SEARCH RESULTS TABLE IMPLEMENTATION <<<<<<<<<<<<<<<<<<<<<<<<< */
        // COULD BUILD PRIVATE METHOD TO ENCAPSULATE CODE? (Both sections of code below and above)
        
        // Create an instance of SearchTableViewController and attach it to LocationSearchTable view controller in the storyboard, accessible in this view controller as locationSearchTable.
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as? SearchTableViewController
        
        // Attach locationSearchTable as the view controller for resultSearchController??
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        
        // Define locationSearchTable as the delegete for searchResultsUpdater
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Navigation bar does not disappear when search results are shown.
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        
        // Modal overlay has a semi-transparent background when the search bar is selected.
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        // Limits modal overlay to view controller's frame (excludes the navigation controller, where the search bar resides).
        definesPresentationContext = true
        
        // Pass handle for mapView to the search table view controller.
        locationSearchTable?.mapView = mapView
        
        /* >>>>>>>>>>>>>>>>>>>>>>>>> END OF SEARCH BAR AND SEARCH RESULTS TABLE IMPLMENTATION  */
        
        locationSearchTable?.handleMapSearchDelegate = self
    }
    
    //MARK: Private Methods
    @objc func getDirections() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // If user choses "Allow" in permissions dialog, trigger location request.
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get latest location from locations array.
        if let location = locations.first {
            
            // Define region size with span value (x and y lengths).
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            // Define zoom region with span size and .coordinate of last location as centre point. Note: .coordinate is a property of type CLLocation.
            let region = MKCoordinateRegionMake(location.coordinate, span)
            
            // Animate zoom to defined zoom region.
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // Delegate must respond to location manager errors.
        print("Error: \(error)")
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // Cache the pin.
        selectedPin = placemark
        
        // Clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        // Create pin on map.
        let pin = MKPointAnnotation() // << DIFFERENT WAY OF TYPING A PROPERTY??
        pin.coordinate = placemark.coordinate
        pin.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            pin.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(pin)
        
        // Zoom map to pin location.
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(pin.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // return nil so map view draws "blue dot" for standard user location.
            return nil
        }
        let reuseId = "marker"
        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        markerView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointFromString("0"), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        markerView?.leftCalloutAccessoryView = button
        return markerView
    }
}
