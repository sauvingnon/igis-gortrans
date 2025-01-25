//
//  MapItem.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 02.02.2024.
//

import SwiftUI
import MapKit

struct MapItem: View {
    
    var transportAnnotation: TransportAnnotation
    
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
                        .foregroundStyle(transportAnnotation.color)
                        .offset(CGSize(width: 0, height: -62))
                    Circle()
                        .foregroundStyle(transportAnnotation.color)
                }
            }
            .rotationEffect(.degrees(Double(transportAnnotation.azimuth)))
            
            Image(transportAnnotation.icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(3)
                .scaleEffect(0.8)
                
            Text(transportAnnotation.route)
                .padding(.horizontal, 5)
                .background(.white)
                .foregroundStyle(.black)
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
    MapItem(transportAnnotation: TransportAnnotation(icon: "bus_icon_white", color: .green, type: .bus, finish_stop: "мкрн Нагорный", current_stop: "ул. Планерная", route: "22", ts_id: "", inPark: true, gosnumber: "М245РУ18", azimuth: 150, coordinate: CLLocationCoordinate2D(
        latitude: 56.843599,
        longitude: 53.202824), priority: 0))
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
