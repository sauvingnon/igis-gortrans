//
//  MapView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI
import MapKit

struct CustomMap: UIViewRepresentable {
    
    private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.843599,
            longitude: 53.202824),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    private static var map = MKMapView()
    public static var useSmallItems = false{
        willSet{
            if newValue != useSmallItems{
                updateAnnotation()
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: CustomMap
        
        init(_ parent: CustomMap) {
            self.parent = parent
        }
        
        // Отображение аннотаций на карте
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            return CustomAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
        
        // Изменение обозреваемого региона
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            if(mapView.region.span.longitudeDelta > 0.07 || mapView.region.span.latitudeDelta > 0.07){
                CustomMap.useSmallItems = true
            }else{
                CustomMap.useSmallItems = false
            }
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let transportAnnotation = view.annotation as? CustomAnnotation{
                
//                view.transform = CGAffineTransformMakeScale(1.5, 1.5);
                
                if(MapModel.shared.sheetIsPresented){
                    withAnimation(.default, {
                        MapModel.shared.routeDescription = getName(type: transportAnnotation.type, number: transportAnnotation.route)
                        MapModel.shared.routeDirection = transportAnnotation.gosnumber
                    })
                }else{
                    MapModel.shared.routeDescription = getName(type: transportAnnotation.type, number: transportAnnotation.route)
                    MapModel.shared.routeDirection = transportAnnotation.gosnumber
                    MapModel.shared.sheetIsPresented = true
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
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
    
    public static func updateAnnotation() {
        CustomMap.map.removeAnnotations(CustomMap.map.annotations)
        CustomMap.map.addAnnotations(MapModel.shared.locations)
    }
    
    func makeCoordinator() -> Coordinator {
        CustomMap.Coordinator(self)
    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        ///  creating a map
        
        /// connecting delegate with the map
        CustomMap.map.delegate = context.coordinator
        CustomMap.map.setRegion(region, animated: true)
        CustomMap.map.mapType = .standard
        CustomMap.map.isRotateEnabled = false
        
        return CustomMap.map
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    let id = UUID()
    let icon: String
    let color: Color
    let type: TypeTransport
    let route: String
    let ts_id: String
    let gosnumber: String
    let azimuth: Int
    let coordinate: CLLocationCoordinate2D
    init(icon: String, color: Color, type: TypeTransport, route: String, ts_id: String, gosnumber: String, azimuth: Int, coordinate: CLLocationCoordinate2D) {
        self.icon = icon
        self.color = color
        self.type = type
        self.route = route
        self.ts_id = ts_id
        self.gosnumber = gosnumber
        self.azimuth = azimuth
        self.coordinate = coordinate
    }
}

class CustomAnnotationView: MKAnnotationView {
    
    static let ReuseID = "cultureAnnotation"
    
    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let annotation = annotation as? CustomAnnotation{
            if CustomMap.useSmallItems {
                let item = MapItemSmall(location: CustomAnnotation(icon: annotation.icon, color: annotation.color, type: annotation.type, route: annotation.route, ts_id: annotation.ts_id, gosnumber: annotation.gosnumber, azimuth: annotation.azimuth, coordinate: annotation.coordinate))
                let vc = UIHostingController(rootView: item)

                let swiftuiView = vc.view!
    //            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
                
                addSubview(swiftuiView)
            }else{
                let item = MapItem(location: CustomAnnotation(icon: annotation.icon, color: annotation.color, type: annotation.type, route: annotation.route, ts_id: annotation.ts_id, gosnumber: annotation.gosnumber, azimuth: annotation.azimuth, coordinate: annotation.coordinate))
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
