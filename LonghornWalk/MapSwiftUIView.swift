//
//  MapSwiftUIView.swift
//  LonghornWalk
//
//  Created by Yousuf Din on 12/4/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import MapKit
import SwiftUI

struct MapSwiftUIView: View {
    
    @State private var directions: [String] = []
    @State private var showDirections = false
    @State var locationManager = CLLocationManager()
    
    var body: some View {
        VStack {
            MapView(directions: $directions)
            
            Button(action: {
                self.showDirections.toggle()
            }, label: {
                Text("Show Directions")
            })
            .disabled(directions.isEmpty)
            .padding()
        }
        .sheet(isPresented: $showDirections, content: {
            VStack {
                Text("Directions")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Divider().background(Color.blue)
                List {
                    ForEach(0..<self.directions.count, id: \.self) { i in
                        Text(self.directions[i])
                            .padding()
                    }
                }
            }
        })
    }
}

struct MapSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapSwiftUIView()
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @Binding var directions: [String]
        
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.2849, longitude: -97.7341), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
                
        let pcl = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: PCL.locationLatitude, longitude: PCL.locationLongitude))
        
        let unb = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: UNB.locationLatitude, longitude: UNB.locationLongitude))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: pcl)
        request.destination = MKMapItem(placemark: unb)
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([pcl, unb])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                      edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30),
                                      animated: true)
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
    }
}
