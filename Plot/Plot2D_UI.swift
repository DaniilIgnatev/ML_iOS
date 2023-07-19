//
//  Plot2D_UI.swift
//  LinearRegression_IOS
//
//  Created by Daniil Ignatev on 19.07.23.
//

import SwiftUI

public struct Plot2D_UI: View {
    
    public init(points: [Point] = [],
                lines: [Line] = [],
                x_lim_step: CGFloat = 5.0,
                x_lim_default: CGFloat = 20.0,
                x_lim: CGFloat = 20.0,
                y_lim_step: CGFloat = 5.0,
                y_lim_default: CGFloat = 20.0,
                y_lim: CGFloat = 20.0
    ) {
        self.points = points
        self.lines = lines
        
        self.x_lim_step = x_lim_step
        self.x_lim_default = x_lim_default
        self.x_lim = x_lim
        
        self.y_lim_step = y_lim_step
        self.y_lim_default = y_lim_default
        self.y_lim = y_lim
    }
    
    public var background_color = Color.init(red: 42 / 255, green: 45 / 255, blue: 44 / 255)
    
    @State public var points: [Point]
    
    @State public var lines: [Line]
    
    let lim_max: CGFloat = 100000
    
    func constrain_lim(_ new_lim: CGFloat) -> CGFloat{
        return max(min(new_lim.magnitude, lim_max), min(x_lim_step, y_lim_step))
    }
    
    @State public var x_lim_step: CGFloat
    
    public let x_lim_default: CGFloat
    
    @State public var x_lim: CGFloat
    
    @State public var y_lim_step: CGFloat
    
    public let y_lim_default: CGFloat
    
    @State public var y_lim: CGFloat
    
    @State private var canvas_isDragging = false
    
    @State private var canvasOffset_last = CGSize.zero
    
    @State private var canvasOffset = CGSize.zero
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                
                ZStack{
                    grid(size: geometry.size)
                    
                    ForEach(lines){ l in
                        draw_line(w0: l.w0, w1: l.w1, size: geometry.size)
                    }
                    
                    ForEach(points){ p in
                        draw_point(x: p.x, y: p.y, size: geometry.size)
                    }
                }
                .offset(canvasOffset)
                
                
                HStack{
                    Spacer()
                    Button("-", action: {
                        DispatchQueue.main.async {
                            self.x_lim = constrain_lim(self.x_lim + self.x_lim_step)
                            self.y_lim = constrain_lim(self.y_lim + self.y_lim_step)
                        }
                    })
                    Spacer()
                    Button("R", action: {
                        DispatchQueue.main.async {
                            withAnimation{
                                self.x_lim = x_lim_default
                                self.y_lim = y_lim_default
                                self.canvasOffset = .zero
                                self.canvasOffset_last = .zero
                            }
                        }
                    })
                    Spacer()
                    Button("+", action:{
                        DispatchQueue.main.async {
                            self.x_lim = constrain_lim(self.x_lim - self.x_lim_step)
                            self.y_lim = constrain_lim(self.y_lim - self.y_lim_step)
                        }
                    })
                    Spacer()
                }
                #if os(watchOS)
                .offset(.init(width: 0, height: 0))
                #else
                .offset(.init(width: 0, height: -15))
                #endif
            }
            .background(background_color)
            .animation(self.canvas_isDragging ? nil : .easeOut, value: self.canvasOffset)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { gesture in
                    //                print("Final Read \(canvasOffset_last)}")
                    let new = CGSize.init(width: canvasOffset_last.width + gesture.translation.width, height: canvasOffset_last.height + gesture.translation.height)
                    DispatchQueue.main.async {
                        self.canvasOffset = new
                        //                    print("Current: \(new)")
                    }
                }
                .onEnded { gesture in
                    DispatchQueue.main.async {
                        let new = CGSize.init(width: canvasOffset_last.width + gesture.predictedEndTranslation.width, height: canvasOffset_last.height + gesture.predictedEndTranslation.height)
                        withAnimation(.easeOut(duration: min(1.5, max(0.5, 0.05 * sqrt(gesture.predictedEndTranslation.width * gesture.predictedEndTranslation.width + gesture.predictedEndTranslation.height * gesture.predictedEndTranslation.height))))){
                            self.canvasOffset = new
                        }
                        self.canvasOffset_last = self.canvasOffset
                        //                    print("Final Write \(canvasOffset_last)}")
                    }
                }
            )
        }
    }
    
    func transform_point(_ point: CGPoint, size: CGSize) -> CGPoint{
        return .init(x: ((point.x + x_lim / 2) * size.width / x_lim), y: ((y_lim - (point.y + y_lim / 2)) * size.height / y_lim))
    }
    
    let line_factor: CGFloat = 10000
    
    func grid(size: CGSize) -> some View{
        ZStack{
            Path { path in
                path.move(to: .init(x: -size.width * line_factor, y: size.height / 2))
                path.addLine(to: .init(x: size.width * line_factor, y: size.height / 2))
            }
            .stroke(Color.black, lineWidth: 2)
            
            Path { path in
                path.move(to: .init(x: size.width / 2, y: -size.height * line_factor))
                path.addLine(to: .init(x: size.width / 2, y: size.height * line_factor))
            }
            .stroke(Color.black, lineWidth: 2)
        }
    }
    
    func draw_line(w0: Double, w1: Double, size: CGSize) -> some View{
        Path { path in
            path.move(to: transform_point(CGPoint(x: -x_lim * line_factor, y: w0 * (-x_lim * line_factor)), size: size))
            path.addLine(to: transform_point(CGPoint(x: x_lim * line_factor, y: w0 * (x_lim * line_factor)), size: size))
        }
        .stroke(Color.red, lineWidth: 2)
    }
    
    func draw_point(x: Double, y: Double, size: CGSize) -> some View{
        return Circle().fill(Color.green)
            .frame(width: 10, height: 10)
            .position(transform_point(.init(x: x, y: y), size: size))
    }
}

struct Plot2D_UI_Previews: PreviewProvider {
    static var previews: some View {
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
