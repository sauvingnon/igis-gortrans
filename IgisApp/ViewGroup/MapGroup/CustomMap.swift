//
//  MapView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 28.02.2023.
//

import SwiftUI
import MapKit

struct CustomMap: UIViewRepresentable {
    
    @Binding var locations: [CustomAnnotation]
    @Binding var region: MKCoordinateRegion
    private static var map = MKMapView()
    public static var useSmallItems = false{
        willSet{
            if newValue != useSmallItems{
                CustomMap.
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: CustomMap
        
        init(_ parent: CustomMap) {
            self.parent = parent
        }
        
        /// showing annotation on the map
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            if annotation is MKClusterAnnotation {
//                return ClusterAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
//            }
            guard let annotation = annotation as? CustomAnnotation else { return nil }
            return CustomAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            if(mapView.region.span.longitudeDelta > 0.07 || mapView.region.span.latitudeDelta > 0.07){
                CustomMap.useSmallItems = true
            }else{
                CustomMap.useSmallItems = false
            }
        }
        
    }
    
    public static func updateAnnotation() {
        CustomMap.map.removeAnnotations(CustomMap.map.annotations)
        CustomMap.map.addAnnotations(CustomMap)
    }
    
    public static func reloadMapAnnotations(){
        let locations =
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
//        CustomMap.map.register(
//        ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier:MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        CustomMap.map.showsCompass = true
        
        return CustomMap.map
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let type: TypeTransport
    let azimuth: Int
    let coordinate: CLLocationCoordinate2D
    init(name: String, icon: String, color: Color, type: TypeTransport, azimuth: Int, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.icon = icon
        self.color = color
        self.type = type
        self.azimuth = azimuth
        self.coordinate = coordinate
        super.init()
    }
}

class ClusterAnnotationView: MKAnnotationView { 
    override var annotation: MKAnnotation? {
        didSet {
            displayPriority = .defaultLow
//            image = UIImage(systemName: "bus")
            let view = UIView(frame: CGRect(x: -25, y: -25, width: 50, height: 50))
            view.backgroundColor = .red
            view.layer.cornerRadius = 25
            addSubview(view)
        }
    }
}

/// here posible to customize annotation view
let clusterID = "clustering"

class CustomAnnotationView: MKAnnotationView {
    
    static let ReuseID = "cultureAnnotation"
    
    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        
        if let annotation = annotation as? CustomAnnotation{
            if CustomMap.useSmallItems {
                let item = MapItemSmall(location: CustomAnnotation(name: annotation.name, icon: annotation.icon, color: annotation.color, type: annotation.type, azimuth: annotation.azimuth, coordinate: annotation.coordinate))
                let vc = UIHostingController(rootView: item)

                let swiftuiView = vc.view!
    //            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
                
                addSubview(swiftuiView)
            }else{
                let item = MapItem(location: CustomAnnotation(name: annotation.name, icon: annotation.icon, color: annotation.color, type: annotation.type, azimuth: annotation.azimuth, coordinate: annotation.coordinate))
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
        displayPriority = .defaultLow
    }
}
