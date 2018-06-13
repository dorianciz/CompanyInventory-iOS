//
//  InventoryMapViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/12/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics

class InventoryMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var items: [Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        fillStaticData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zoomToCurrentLocation()
    }
    
    private func fillStaticData() {
        navigationItem.title = NSLocalizedString(Constants.LocalizationKeys.kMapItemsTitle, comment: "")
    }
    
    private func zoomToCurrentLocation() {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span.latitudeDelta = 0.2
        mapRegion.span.longitudeDelta = 0.2
        
        mapView.setRegion(mapRegion, animated: true)
    }
    
    private func addAnnotations() {
        items?.forEach({ (item) in
            let itemAnnotation = MKPointAnnotation()
            itemAnnotation.title = item.name
            itemAnnotation.subtitle = item.locationName
            itemAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(item.latitude.value!), longitude: CLLocationDegrees(item.longitude.value!))
            mapView.addAnnotation(itemAnnotation)
        })
    }

}

extension InventoryMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.kCalloutViewIdentifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.kCalloutViewIdentifier)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
}
