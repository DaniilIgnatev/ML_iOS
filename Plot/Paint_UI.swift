//
//  Paint_UI.swift
//  Plot
//
//  Created by Daniil Ignatev on 28.07.23.
//

import SwiftUI

public struct Paint_UI: View {
    public init(points: Binding<[Point]>){
        self._points = points
    }
    
    public let background_color = Color.init(red: 42 / 255, green: 45 / 255, blue: 44 / 255)
    
    @Binding public var points: [Point]
    
    let point_size: CGFloat = 4
    
    public var body: some View {
        GeometryReader { geometry in
            ForEach(points, id: \.self) { point in
                            Circle()
                                .fill(Color.green)
                                .frame(width: self.point_size, height: self.point_size)
                                .position(x: point.x, y: point.y)
                        }
        }
        .background(background_color)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let location = value.location

                        let point = Point(location)
                        points.append(point)
                }
        )
    }
}

struct Paint_UI_Previews: PreviewProvider {
    static var previews: some View {
        Paint_UI(points: .constant([]))
    }
}
