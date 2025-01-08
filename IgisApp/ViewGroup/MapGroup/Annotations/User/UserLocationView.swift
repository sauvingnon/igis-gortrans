//
//  UserLocationView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 22.07.2024.
//

import Foundation
import MapKit
import SwiftUI

class UserLocationView: MKAnnotationView {
    
    static let ReuseID = "userLocation"
    
    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let annotation = annotation as? MKUserLocation{
            
            let item = MapUserLocation(userLocation: annotation)
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
