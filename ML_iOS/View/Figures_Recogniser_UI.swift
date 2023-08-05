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
        static let dimensions_size: Int = 32
    }

    @State var points_ui: [Point] = []
    
    @State var classification_result = ""
    
    var body: some View {
        let paint_ui = Paint_UI(points: self.$points_ui)

        VStack{
            HStack(spacing: 20){
                Text(classification_result)
            }
            
            paint_ui
            
            HStack(spacing: 20){
                Button("Classify") {
                    self.classify()
                }

                Button("Clear") {
                    paint_ui.points.removeAll()
                }
            }
        }
    }
    
    private func classify(){
        classification_result = "unknown"
        
        var normalized_points = self.normalize(points: self.points_ui)
        normalized_points = self.interpolate(points: normalized_points)
        normalized_points = self.interpolate(points: normalized_points)
        let sample = generate_sample(from: normalized_points)
        
        self.points_ui = normalized_points
    }
    
    private func interpolate(points: [Point]) -> [Point]{
        var interpolated_index_points = [(Int, Point)]()
        var varinterpolated_points = points
        
        for i in 0..<(points.count - 1){
            let p1 = points[i]
            let p2 = points[i + 1]
            
            let middle_point = Point.linear_interpolation(p1: p1, p2: p2)
            varinterpolated_points.insert(middle_point, at: i*2 + 1)
        }
        
        return varinterpolated_points
    }
    
    private func normalize(points: [Point]) -> [Point]{
        let bounding_box = getBox(points: points)!
        let shifted_points = shiftToZero(points: points, bounding_box: bounding_box)
        let scaled_points = scalePoints(points: shifted_points, bounding_box: bounding_box)
        
        return scaled_points
    }
    
    private func getBox(points: [Point]) -> CGRect? {
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

        return .init(x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1)
    }
    
    private func shiftToZero(points: [Point], bounding_box: CGRect) -> [Point]{
        return points.map({$0.shiftBy(x: -bounding_box.minX, y: -bounding_box.minY)})
    }
    
    private func scalePoints(points: [Point], bounding_box: CGRect) -> [Point]{
        return points.map { $0
            .scalePoint(xFactor: CGFloat(Constants.dimensions_size - 1) / bounding_box.width, yFactor: CGFloat(Constants.dimensions_size - 1) / bounding_box.height)
        }
    }

    private func generate_sample(from points: [Point]) -> [CGFloat]{
        var sample = [CGFloat].init(repeating: -1.0, count: Constants.dimensions_size * Constants.dimensions_size)
        points.forEach({sample[Int($0.y) * Constants.dimensions_size + Int($0.x)] = 99.0})
        
        return sample
    }
}

struct Figures_Recogniser_UI_Previews: PreviewProvider {
    static var previews: some View {
        Figures_Recogniser_UI()
    }
}
