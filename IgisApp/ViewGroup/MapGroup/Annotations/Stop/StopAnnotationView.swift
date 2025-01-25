//
//  StopAnnotationView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 22.07.2024.
//

import Foundation
import MapKit
import SwiftUI

class StopAnnotationView: MKAnnotationView {
    
    static let ReuseID = "cultureAnnotation"
    
    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let annotation = annotation as? StopAnnotation{
            
            let item = MapStop(stopAnnotation: StopAnnotation(stop_id: annotation.stop_id, stop_name: annotation.stop_name, stop_name_short: annotation.stop_name_short, color: annotation.color, stop_direction: annotation.stop_direction, stop_types: annotation.stop_types, coordinate: annotation.coordinate, stop_demand: annotation.stop_demand, letter: annotation.letter, priority: 0))
            let vc = UIHostingController(rootView: item)

            let swiftuiView = vc.view!
//            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
            swiftuiView.layer.zPosition = 1
            
            addSubview(swiftuiView)
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
