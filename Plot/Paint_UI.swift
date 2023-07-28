//
//  Paint_UI.swift
//  Plot
//
//  Created by Daniil Ignatev on 28.07.23.
//

import SwiftUI

public struct Paint_UI: View {
    public init(points: Binding<[CGPoint]>){
        self._points = points
    }
    
    @Binding public var points: [CGPoint]
    
    public var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.addLines(points)
            }
            .stroke(Color.black, lineWidth: 1)
            .background(Color.white)
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged { value in
                        let location = value.location
                        
                        // Make sure the point is within the drawing area
                        if geometry.frame(in: .local).contains(location) {
                            points.append(location)
                        }
                    }
            )
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct Paint_UI_Previews: PreviewProvider {
    static var previews: some View {
        Paint_UI(points: .constant([]))
    }
}
