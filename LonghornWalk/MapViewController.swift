//
//  MapViewController.swift
//  LonghornWalk
//
//  Created by Yousuf Din on 12/4/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ModalViewControllerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    var directions: [String] = []
    
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.2849, longitude: -97.7341), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        map.setRegion(region, animated: true)
        
        getAddress()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        map.delegate = self
    }
    
    @IBAction func getDirectionsTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DirectionsViewController") as? DirectionsViewController {
            vc.directions = directions
            vc.delegate = self;
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func sendValue(var value: NSString) {

    }
    
    func getAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("No Location Found")
                return
            }
            print(location)
            self.mapThis(destinationCord: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func mapThis(destinationCord: CLLocationCoordinate2D) {
        let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        destinationRequest.transportType = .walking
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Something is wrong")
                }
                return
            }
            let route = response.routes[0]
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30), animated: true)
            self.directions = route.steps.map { $0.instructions }.filter{ !$0.isEmpty }
        }

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .systemOrange
        render.lineWidth = 3
        return render
    }

}
