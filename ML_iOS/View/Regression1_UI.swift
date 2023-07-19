//
//  Regression1_UI.swift
//  LinearRegression_IOS
//
//  Created by Daniil Ignatev on 19.07.23.
//

import SwiftUI
import Plot

struct Regression1_UI: View {
    
    @State private var w0: Double = 0.7
    
    var body: some View {
        Plot2D_UI(points: [
            .init(x: 1, y: 3),
            .init(x: 2, y: 4),
            .init(x: 3, y: 0),
            .init(x: 6, y: 4)
        ],
                  lines: [
                    .init(w0: 0.7, w1: 0)
                  ])
    }
}

struct Regression1_UI_Previews: PreviewProvider {
    static var previews: some View {
        Regression1_UI()
    }
}
