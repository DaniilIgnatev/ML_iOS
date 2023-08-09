//
//  Figures_Recogniser_UI.swift
//  ML_iOS
//
//  Created by Daniil Ignatev on 28.07.23.
//

import SwiftUI
import Plot
import Math

public struct Figures_Recogniser_UI: View {
    enum Constants {
        static let dimensions_size: Int = 32
    }
    
    public init(){
        
    }
    
    public let background_color = Color.init(red: 42 / 255, green: 45 / 255, blue: 44 / 255)
    
    @State var points_ui: [Point] = []
    
    @State var classification_result = ""
    
    let noise_classifier = NeuralNetwork(name: "Noise", hidden_layers_number: 2)
    
    let line_classifier = NeuralNetwork(name: "Line", hidden_layers_number: 2)
    
    let triangle_classifier = NeuralNetwork(name: "Triangle", hidden_layers_number: 2)
    
    let rectangle_classifier = NeuralNetwork(name: "Rectangle", hidden_layers_number: 2)
    
    let ellipse_classifier = NeuralNetwork(name: "Ellipse", hidden_layers_number: 2)
    
    public var body: some View {
        let paint_ui = Paint_UI(points: self.$points_ui)
        
        ZStack{
            VStack{
                paint_ui
                
                HStack(spacing: 20){
                    Button("Check") {
                        self.classify()
                    }
                    
                    Button("Clear") {
                        classification_result = ""
                        paint_ui.points.removeAll()
                    }
                }
            }
            
            VStack{
                Text(self.classification_result)
                    .foregroundColor(.red)
                
                Spacer()
            }
        }
        .background(background_color)
    }
    
    private func classify(){
        classification_result = "unknown"
        
        guard self.points_ui.count > 1 else{
            return
        }
        
        var interpolated_points = self.interpolate(points: self.points_ui)
        interpolated_points = self.interpolate(points: interpolated_points)
        
        let normalized_points = self.normalize(points: interpolated_points)
        
        let sample = generate_sample(from: normalized_points)
        
        let noise_p = try! noise_classifier.forwardPropagation(input: sample).first ?? 0.0
        let line_p = try! line_classifier.forwardPropagation(input: sample).first ?? 0.0
        let triangle_p = try! triangle_classifier.forwardPropagation(input: sample).first ?? 0.0
        let rectangle_p = try! rectangle_classifier.forwardPropagation(input: sample).first ?? 0.0
        let ellipse_p = try! ellipse_classifier.forwardPropagation(input: sample).first ?? 0.0
        
        let P = [noise_p, line_p, triangle_p, rectangle_p, ellipse_p]
        print("P=\(P)")
        
        let P_SM = Num.softmax(x: P)
        print("P_softmax=\(P_SM)")
        let names = ["Noise", "Line", "Triangle", "Rectangle", "Ellipse"]
        
        let indexOfLargest = P_SM.enumerated().max(by: { $0.element < $1.element })!.offset
        let Name_largest = names[indexOfLargest]
        
        var P_SM_R = P_SM
        P_SM_R.remove(at: indexOfLargest)
        let indexOfSecondLargest = P_SM_R.enumerated().max(by: { $0.element < $1.element })!.offset
        var names_r = names
        names_r.remove(at: indexOfLargest)
        let Name_second_largest = names_r[indexOfSecondLargest]
        
        if Num.truncateDouble(value: P_SM[indexOfLargest], toDecimalPlaces: 4) == Num.truncateDouble(value: P_SM_R[indexOfSecondLargest], toDecimalPlaces: 4){
            self.classification_result = "\(Name_largest) or \(Name_second_largest)"
        }
        else{
            self.classification_result = "\(Name_largest)"
        }
        
        print(self.classification_result)
        
        //        self.points_ui.append(contentsOf: normalized_points)
    }
    
    private func interpolate(points: [Point]) -> [Point]{
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
    
    private func generate_sample(from points: [Point]) -> [Double]{
        var sample = [Double].init(repeating: -1.0, count: Constants.dimensions_size * Constants.dimensions_size)
        points.forEach({sample[Int($0.y) * Constants.dimensions_size + Int($0.x)] = 1.0})
        
        return sample
    }
}

struct Figures_Recogniser_UI_Previews: PreviewProvider {
    static var previews: some View {
        Figures_Recogniser_UI()
    }
}
