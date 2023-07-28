//
//  Figures_Recogniser_UI.swift
//  ML_iOS
//
//  Created by Daniil Ignatev on 28.07.23.
//

import SwiftUI
import Plot

struct Figures_Recogniser_UI: View {
    @State var points: [CGPoint] = []
    
    var body: some View {
        let paint_ui = Paint_UI(points: self.$points)
        
        VStack{
            paint_ui
            HStack{
                Button("Classify"){
                    let box = self.get_box()
                    print(box)
                }
            }
        }
    }
    
    func get_box() -> CGRect{
        let min_x: CGFloat = points.min(by: {
            $0.x < $1.x
        })!.x
        let min_y: CGFloat = points.min(by: {
            $0.y < $1.y
        })!.y
//        let min_point = CGPoint(x: min_x, y: min_y)
//        print(min_point)
        
        let max_x: CGFloat = points.max(by: {
            $0.x < $1.x
        })!.x
        let max_y: CGFloat = points.max(by: {
            $0.y < $1.y
        })!.y
        
//        let max_point = CGPoint(x: max_x, y: max_y)
//        print(max_point)
        
        return .init(x: min_x, y: min_y, width: max_x - min_x, height: max_y - min_y)
    }
}

struct Figures_Recogniser_UI_Previews: PreviewProvider {
    static var previews: some View {
        Figures_Recogniser_UI()
    }
}
