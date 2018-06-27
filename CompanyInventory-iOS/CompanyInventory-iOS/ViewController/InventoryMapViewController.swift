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
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemLocationLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    @IBOutlet weak var detailsViewTrailingConstraint: NSLayoutConstraint!
    
    
    private var currentAnnotation: MKAnnotation?
    
    var items: [Item]?
    var itemDetailsBrain = ItemDetailsBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        applyStyles()
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
    
    private func applyStyles() {
        ThemeManager.sharedInstance.styleBoldLabel(itemNameLabel)
        ThemeManager.sharedInstance.styleDefaultLabel(itemDescriptionLabel)
        self.detailsViewTrailingConstraint.constant = Constants.mapDetailsViewHiddenConstraint
        self.view.layoutIfNeeded()
        setDetailsViewAlpha(0)
        detailsView.layer.cornerRadius = ThemeManager.sharedInstance.buttonDefaultCornerRadius
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
            
            if let name = item.name, let locationName = item.locationName, let description = item.descriptionText, let photoPath = item.photoLocalPath {
                let itemAnnotation = ItemAnnotation(name, description, locationName, photoPath, CLLocationCoordinate2D(latitude: CLLocationDegrees(item.latitude.value!), longitude: CLLocationDegrees(item.longitude.value!)))
                mapView.addAnnotation(itemAnnotation)
            }
        })
    }
    
    private func setDetailsViewAlpha(_ alpha: CGFloat) {
        detailsView.alpha = alpha
        itemImageView.alpha = alpha
        itemNameLabel.alpha = alpha
        itemDescriptionLabel.alpha = alpha
        itemLocationLabel.alpha = alpha
    }
    
    @objc func markerInfoButtonAction(_ sender: Any?) {
        if let currentAnnotation = self.currentAnnotation as? ItemAnnotation {
            self.itemNameLabel.text = currentAnnotation.name
            self.itemDescriptionLabel.text = currentAnnotation.descriptionText
            self.itemLocationLabel.text = currentAnnotation.locationName
            self.itemImageView.image = self.itemDetailsBrain.getImage(forPath: currentAnnotation.photoPath)
        }
        
        AnimationChainingFactory.sharedInstance
            .animation(withDuration: 1, withDelay: 0, withAnimations: {
            self.setDetailsViewAlpha(0.9)
                self.detailsViewTrailingConstraint.constant = Constants.mapDetailsViewShownConstraint
            self.view.layoutIfNeeded()
        }, withCompletion: {

        }, withOptions: .transitionCrossDissolve ).run()
    }

}

extension InventoryMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }

        let ann = annotation as? ItemAnnotation

        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.kCalloutViewIdentifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = ann
            view = dequeuedView
        } else {
            let infoButton = UIButton(type: .detailDisclosure)
            infoButton.addTarget(self, action: #selector(markerInfoButtonAction(_:)), for: .touchUpInside )
            
            view = MKMarkerAnnotationView(annotation: ann, reuseIdentifier: Constants.kCalloutViewIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = infoButton
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Select")
        currentAnnotation = view.annotation
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("Deselect")
        AnimationChainingFactory.sharedInstance.animation(withDuration: 1, withDelay: 0, withAnimations: {
            self.detailsViewTrailingConstraint.constant = Constants.mapDetailsViewHiddenConstraint
            self.view.layoutIfNeeded()
            self.setDetailsViewAlpha(0)
        }, withCompletion: {}, withOptions: .transitionCrossDissolve ).run()
    }
    
}
