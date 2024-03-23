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
    
    private let locationManager = CLLocationManager()
    
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
            if newValue != showStops{
                if(newValue){
                    appendStopsAnnotation()
                }else{
                    removeStopsAnnotation()
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
            
            return nil
        }
        
        // Изменение обозреваемого региона
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            if(mapView.region.span.longitudeDelta > 0.05 || mapView.region.span.latitudeDelta > 0.05){
                CustomMap.useSmallItems = true
            }else{
                CustomMap.useSmallItems = false
            }
            
            if(mapView.region.span.longitudeDelta > 0.016 || mapView.region.span.latitudeDelta > 0.016){
                CustomMap.showStops = false
            }else{
                CustomMap.showStops = true
            }
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            if let stopAnnotation = view.annotation as? StopAnnotation{
                MapModel.shared.selectedStopAnnotation = stopAnnotation
                MapModel.shared.selectedTransportAnnotation = nil
                mapView.setRegion(MKCoordinateRegion(center: stopAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)), animated: true)
                
                if(MapModel.shared.sheetIsPresented){
                    withAnimation(.default, {
                        MapModel.shared.mainText = stopAnnotation.stop_name ?? ""
                        MapModel.shared.secondText = stopAnnotation.stop_direction ?? ""
                        MapModel.shared.thirdText = MapViewModel.shared.getStringOfTypesTransport(types: stopAnnotation.stop_types)
                        MapModel.shared.inPark = false
                    })
                }else{
                    MapModel.shared.mainText = stopAnnotation.stop_name ?? ""
                    MapModel.shared.secondText = stopAnnotation.stop_direction ?? ""
                    MapModel.shared.thirdText = MapViewModel.shared.getStringOfTypesTransport(types: stopAnnotation.stop_types)
                    MapModel.shared.inPark = false
                    MapModel.shared.sheetIsPresented = true
                }
            }
            
            if let transportAnnotation = view.annotation as? TransportAnnotation{
                MapModel.shared.selectedStopAnnotation = nil
                MapModel.shared.selectedTransportAnnotation = transportAnnotation
                mapView.setRegion(MKCoordinateRegion(center: transportAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)), animated: true)
                
                if(MapModel.shared.sheetIsPresented){
                    withAnimation(.default, {
                        MapModel.shared.mainText = getName(type: transportAnnotation.type, number: transportAnnotation.route)
                        MapModel.shared.secondText = transportAnnotation.current_stop
                        MapModel.shared.thirdText = transportAnnotation.finish_stop
                        MapModel.shared.inPark = transportAnnotation.inPark
                    })
                }else{
                    MapModel.shared.mainText = getName(type: transportAnnotation.type, number: transportAnnotation.route)
                    MapModel.shared.secondText = transportAnnotation.current_stop
                    MapModel.shared.thirdText = transportAnnotation.finish_stop
                    MapModel.shared.inPark = transportAnnotation.inPark
                    MapModel.shared.sheetIsPresented = true
                }
                
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            
        }
        
        private func getName(type: TypeTransport, number: String) -> String {
            switch type {
            case .bus:
                return "АВТОБУС № \(number)"
            case .train:
                return "ТРАМВАЙ №\(number)"
            case .trolleybus:
                return "ТРОЛЛЕЙБУС №\(number)"
            case .countrybus:
                return "АВТОБУС №\(number)"
            }
        }
        
    }
    
    public static func setRegionOnUserLocation(){
        if let coordinate = userLocation?.coordinate {
            map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        }
        
    }
    
    public static func updateTransportAnnotation() {
        
        let transportAnnotations = CustomMap.map.annotations.filter { annotation in
            annotation is TransportAnnotation
        }
        
        CustomMap.map.removeAnnotations(transportAnnotations)
        CustomMap.map.addAnnotations(MapModel.shared.transportAnnotations)
    }
    
    public static func appendStopsAnnotation(){
        CustomMap.map.addAnnotations(MapModel.shared.stopAnnotations)
    }
    
    public static func removeStopsAnnotation(){
        CustomMap.map.removeAnnotations(MapModel.shared.stopAnnotations)
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
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = context.coordinator
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        return CustomMap.map
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

class TransportAnnotation: NSObject, MKAnnotation {
    let id = UUID()
    let icon: String
    let color: Color
    let type: TypeTransport
    let finish_stop: String
    let current_stop: String
    let route: String
    let ts_id: String
    let inPark: Bool
    let gosnumber: String
    let azimuth: Int
    let coordinate: CLLocationCoordinate2D
    init(icon: String, color: Color, type: TypeTransport, finish_stop: String, current_stop: String, route: String, ts_id: String, inPark: Bool, gosnumber: String, azimuth: Int, coordinate: CLLocationCoordinate2D) {
        self.icon = icon
        self.color = color
        self.type = type
        self.finish_stop = finish_stop
        self.current_stop = current_stop
        self.route = route
        self.ts_id = ts_id
        self.inPark = inPark
        self.gosnumber = gosnumber
        self.azimuth = azimuth
        self.coordinate = coordinate
    }
}

class StopAnnotation: NSObject, MKAnnotation {
    let id = UUID()
    let stop_id: Int
    let stop_name: String?
    let stop_name_short: String?
    let color: Color
    let stop_direction: String?
    let stop_types: [TypeTransport]
    let coordinate: CLLocationCoordinate2D
    let stop_demand: Int?
    
    init(stop_id: Int, stop_name: String?, stop_name_short: String?, color: Color, stop_direction: String?, stop_types: [TypeTransport], coordinate: CLLocationCoordinate2D, stop_demand: Int?) {
        self.stop_id = stop_id
        self.stop_name = stop_name
        self.stop_name_short = stop_name_short
        self.color = color
        self.stop_direction = stop_direction
        self.stop_types = stop_types
        self.coordinate = coordinate
        self.stop_demand = stop_demand
    }
}

class StopAnnotationView: MKAnnotationView {
    
    static let ReuseID = "cultureAnnotation"
    
    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let annotation = annotation as? StopAnnotation{
            
            let item = MapStop(stopAnnotation: StopAnnotation(stop_id: annotation.stop_id, stop_name: annotation.stop_name, stop_name_short: annotation.stop_name_short, color: annotation.color, stop_direction: annotation.stop_direction, stop_types: annotation.stop_types, coordinate: annotation.coordinate, stop_demand: annotation.stop_demand))
            let vc = UIHostingController(rootView: item)

            let swiftuiView = vc.view!
//            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(swiftuiView)
        }
        
        prepareForDisplay()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
    }
}

class TransportAnnotationView: MKAnnotationView {
    
    static let ReuseID = "cultureAnnotation"
    
    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let annotation = annotation as? TransportAnnotation{
            if CustomMap.useSmallItems {
                let item = MapItemSmall(transportAnnotation: TransportAnnotation(icon: annotation.icon, color: annotation.color, type: annotation.type, finish_stop: annotation.finish_stop, current_stop: annotation.current_stop, route: annotation.route, ts_id: annotation.ts_id, inPark: annotation.inPark, gosnumber: annotation.gosnumber, azimuth: annotation.azimuth, coordinate: annotation.coordinate))
                let vc = UIHostingController(rootView: item)

                let swiftuiView = vc.view!
    //            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
                
                addSubview(swiftuiView)
            }else{
                let item = MapItem(transportAnnotation: TransportAnnotation(icon: annotation.icon, color: annotation.color, type: annotation.type, finish_stop: annotation.finish_stop, current_stop: annotation.current_stop, route: annotation.route, ts_id: annotation.ts_id, inPark: annotation.inPark, gosnumber: annotation.gosnumber, azimuth: annotation.azimuth, coordinate: annotation.coordinate))
                let vc = UIHostingController(rootView: item)

                let swiftuiView = vc.view!
    //            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
                
                addSubview(swiftuiView)
            }
            
        }
        
        prepareForDisplay()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
    }
}
