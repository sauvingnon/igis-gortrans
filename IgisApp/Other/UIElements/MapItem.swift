//
//  MapItem.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.02.2024.
//

import SwiftUI
import MapKit

struct MapItem: View {
    
    var location: LocationTransport
    
    var body: some View {
        ZStack{
            ZStack{
                ZStack{
                    Triangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                        .offset(CGSize(width: 0, height: -62))
                    Circle()
                        .foregroundStyle(.white)
                }
                .scaleEffect(1.2)
                ZStack{
                    Triangle(cornerRadius: 10)
                        .foregroundStyle(location.color)
                        .offset(CGSize(width: 0, height: -62))
                    Circle()
                        .foregroundStyle(location.color)
                }
            }
            .rotationEffect(.degrees(Double(location.azimuth)))
            
            Image(systemName: location.icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(3)
                .scaleEffect(0.8)
                
            Text(location.name)
                .padding(.horizontal, 5)
                .background(.white)
                .cornerRadius(10)
                .position(x: 120, y: 120)
                .font(.system(size: 50))
                .minimumScaleFactor(0.01)
        }
        .frame(width: 100, height: 100)
        .scaleEffect(0.2)
    }
}

#Preview {
    MapItem(location: LocationTransport(name: "21", icon: "bus", coordinate: CLLocationCoordinate2D(latitude: 56.0, longitude: 53.0), color: .green, type: .bus, azimuth: 0))
}

private struct Triangle: Shape {
  let cornerRadius: CGFloat
  
  func path(in rect: CGRect) -> Path {
    let width = rect.width
    let height = rect.height
    
    // The triangle's three corners.
    let bottomLeft = CGPoint(x: 0, y: height)
    let bottomRight = CGPoint(x: width, y: height)
    let topMiddle = CGPoint(x: rect.midX, y: 0)
    
    // We'll start drawing from the bottom middle of the triangle,
    // the midpoint between the two lower corners.
    let bottomMiddle = CGPoint(x: rect.midX, y: height)
    
    // Draw three arcs to trace the triangle.
    var path = Path()
    path.move(to: bottomMiddle)
    path.addArc(tangent1End: bottomRight, tangent2End: topMiddle, radius: cornerRadius)
    path.addArc(tangent1End: topMiddle, tangent2End: bottomLeft, radius: cornerRadius)
    path.addArc(tangent1End: bottomLeft, tangent2End: bottomRight, radius: cornerRadius)
    
    return path
  }
}
