//
//  Figures_Recogniser_UI.swift
//  ML_iOS
//
//  Created by Daniil Ignatev on 28.07.23.
//

import SwiftUI
import Plot

struct Figures_Recogniser_UI: View {
    enum Constants {
        static let maxDimensionLength: CGFloat = 16
    }

    @State var points: [CGPoint] = []
    
    var body: some View {
        let paint_ui = Paint_UI(points: self.$points)

        VStack{
            paint_ui
            HStack(spacing: 20){
                Button("Classify") {
                    guard let box = self.getBox() else {
                        return
                    }

                    points = points.map {
                        $0
                            .shiftBy(x: box.minX, y: box.minY)
                            .scalePoint(xFactor: getScaleFactor(for: box.width), yFactor: getScaleFactor(for: box.height))
                    }
                    
                    print(points)
                }

                Button("Clear") {
                    paint_ui.points.removeAll()
                }
            }
        }
    }
    
    private func getBox() -> CGRect? {
        let min_x = points.min {
            $0.x < $1.x
        }?.x
        let min_y = points.min {
            $0.y < $1.y
        }?.y
        
        let max_x = points.max {
            $0.x < $1.x
        }?.x
        let max_y = points.max {
            $0.y < $1.y
        }?.y

        guard let minX = min_x, let minY = min_y, let maxX = max_x, let maxY = max_y else {
            return nil
        }

        return .init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    private func getScaleFactor(for value: CGFloat) -> CGFloat {
        1 / (value / Constants.maxDimensionLength)
    }
}

struct Figures_Recogniser_UI_Previews: PreviewProvider {
    static var previews: some View {
        Figures_Recogniser_UI()
    }
}

extension CGPoint {
    func shiftBy(x: CGFloat, y: CGFloat) -> CGPoint {
        CGPoint(x: self.x - x, y: self.y - y)
    }

    func scalePoint(xFactor: CGFloat, yFactor: CGFloat) -> CGPoint {
        CGPoint(x: x * xFactor, y: y * yFactor)
    }
}
