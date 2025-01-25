//
//  TransportAnnotationView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 22.07.2024.
//

import Foundation
import MapKit
import SwiftUI

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
                swiftuiView.layer.zPosition = 0
                
                addSubview(swiftuiView)
            }else{
                let item = MapItem(transportAnnotation: TransportAnnotation(icon: annotation.icon, color: annotation.color, type: annotation.type, finish_stop: annotation.finish_stop, current_stop: annotation.current_stop, route: annotation.route, ts_id: annotation.ts_id, inPark: annotation.inPark, gosnumber: annotation.gosnumber, azimuth: annotation.azimuth, coordinate: annotation.coordinate))
                let vc = UIHostingController(rootView: item)

                let swiftuiView = vc.view!
    //            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
                swiftuiView.layer.zPosition = 0
                
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
