//
//  MapView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI
import MapKit
import CoreLocation

struct CustomMap: UIViewRepresentable {
    
    private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    public static let locationManager = CLLocationManager()
    
    private static var userLocation: CLLocation?
    
    private static var map = MKMapView()
    public static var useSmallItems = false{
        willSet{
            if newValue != useSmallItems{
                updateTransportAnnotation()
            }
        }
    }
    
    public static var showStops = false{
        willSet{
            if(MapModel.shared.selectedTransportAnnotation != nil || MapModel.shared.selectedStopAnnotation != nil || MapModel.shared.selectedRouteId != nil){
                return
            }
            if newValue != showStops{
                if(newValue){
                    appendStopsAnnotation(stopAnnotations: MapModel.shared.stopAnnotations)
                }else{
                    removeStopsAnnotation(stopAnnotations: MapModel.shared.stopAnnotations)
                }
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        
        var parent: CustomMap
        
        init(_ parent: CustomMap) {
            self.parent = parent
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            let locValue: CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            userLocation = locations.last
            
        }
        
        // Отображение аннотаций на карте
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if(annotation is TransportAnnotation){
                return TransportAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
            
            if(annotation is StopAnnotation){
                return StopAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
            
            if annotation.isEqual(mapView.userLocation) {
                return UserLocationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
            
            return nil
        }
        
        // Изменение обозреваемого региона
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            if(mapView.region.span.longitudeDelta > 0.05 || mapView.region.span.latitudeDelta > 0.05){
                CustomMap.useSmallItems = true
            }else{
                CustomMap.useSmallItems = false
            }
            
            reloadStopAnnotationsOnMap(rightNow: false)
        }
        
        // Обработка нажатия на аннотации
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            if let stopAnnotation = view.annotation as? StopAnnotation{
                MapViewModel.shared.selectStopAnnotation(stopAnnotation: stopAnnotation)
            }
            
            if let transportAnnotation = view.annotation as? TransportAnnotation{
                MapViewModel.shared.selectTransportAnnotation(transportAnnotation: transportAnnotation)
            }
        }
        
        // Отрисовка линий на карте
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            polylineRenderer.strokeColor = UIColor(red: 0.4, green: 0.4, blue: 1, alpha: 0.5)
            polylineRenderer.lineWidth = 4.0
            return polylineRenderer
          }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            
        }

    }
    
    public static func reloadStopAnnotationsOnMap(rightNow: Bool){
        
        if(rightNow){
            if(map.region.span.longitudeDelta > 0.01 || map.region.span.latitudeDelta > 0.01){
                removeStopsAnnotation(stopAnnotations: MapModel.shared.stopAnnotations)
            }else{
                appendStopsAnnotation(stopAnnotations: MapModel.shared.stopAnnotations)
            }
            return
        }
        
        if(map.region.span.longitudeDelta > 0.01 || map.region.span.latitudeDelta > 0.01){
            CustomMap.showStops = false
        }else{
            CustomMap.showStops = true
        }
    }
    
    public static func setRegionOnUserLocation(){
        if let coordinate = userLocation?.coordinate {
            map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        }
    }
    
    public static func setRegion(region: MKCoordinateRegion){
        map.setRegion(region, animated: true)
    }
    
    public static func deselectAnnotation(annotation: MKAnnotation){
        map.deselectAnnotation(annotation, animated: true)
    }
    
    public static func updateTransportAnnotation() {
        
        let transportAnnotations = CustomMap.map.annotations.filter { annotation in
            annotation is TransportAnnotation
        }
        
        CustomMap.map.removeAnnotations(transportAnnotations)
        CustomMap.map.addAnnotations(MapModel.shared.transportAnnotations)
    }
    
    public static func appendLines(points: [CLLocationCoordinate2D]){
        CustomMap.map.addOverlay(MKPolyline(coordinates: points, count: points.count))
    }
    
    public static func removeAllLines(){
        CustomMap.map.removeOverlays(map.overlays)
    }
    
    public static func appendStopsAnnotation(stopAnnotations: [StopAnnotation]){
        CustomMap.map.addAnnotations(stopAnnotations)
    }
    
    public static func removeStopsAnnotation(stopAnnotations: [StopAnnotation]){
        CustomMap.map.removeAnnotations(stopAnnotations)
    }
    public static func loadMapIfNeeded(){
        
    }
    
    func makeCoordinator() -> Coordinator {
        CustomMap.Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {

        ///  creating a map
        
        /// connecting delegate with the map
        CustomMap.map.delegate = context.coordinator
        CustomMap.map.mapType = .standard
        CustomMap.map.isRotateEnabled = false
        CustomMap.map.showsUserLocation = true
        CustomMap.map.setRegion(region, animated: true)
        
        // For use in foreground
        CustomMap.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                CustomMap.locationManager.delegate = context.coordinator
                CustomMap.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                CustomMap.locationManager.startUpdatingLocation()
            }
        }
        
        return CustomMap.map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}







