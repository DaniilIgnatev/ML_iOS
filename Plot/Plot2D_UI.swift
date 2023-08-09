//
//  Plot2D_UI.swift
//  LinearRegression_IOS
//
//  Created by Daniil Ignatev on 19.07.23.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

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
    
    public let background_color = Color.init(red: 42 / 255, green: 45 / 255, blue: 44 / 255)
    
    @State public var points: [Point]
    
    @State public var lines: [Line]
    
    let lim_max: CGFloat = 100000
    
    func constrain_lim(_ new_lim: CGFloat) -> CGFloat{
        let lim_min = min(x_lim_step, y_lim_step)
        var new_lim = new_lim
        
        if new_lim < lim_min{
            new_lim = lim_min
        }
        if new_lim > lim_max{
            new_lim = lim_max
        }
        
        return new_lim
    }
    
    @State public var x_lim_step: CGFloat
    
    public let x_lim_default: CGFloat
    
    @State public var x_lim: CGFloat
    
    private func x_lim_add(step: CGFloat){
        self.x_lim = constrain_lim(self.x_lim + step)
    }
    
    @State public var y_lim_step: CGFloat
    
    public let y_lim_default: CGFloat
    
    @State public var y_lim: CGFloat
    
    private func y_lim_add(step: CGFloat){
        self.y_lim = constrain_lim(self.y_lim + step)
    }
    
    @State private var canvas_isDragging = false
    
    @State private var canvasOffset_last = CGSize.zero
    
    @State private var canvasOffset = CGSize.zero
    
    @State private var scale: CGFloat = 1.0
    
    @State private var lastScale: CGFloat = 1.0
    
    @State private var scale_cumulative: CGFloat = 0.0
    
    func scale_lim(speed: CGFloat){
        let x_lim_step = speed * self.x_lim_step
        let y_lim_step = speed * self.y_lim_step
        
        self.x_lim_add(step: x_lim_step)
        self.y_lim_add(step: y_lim_step)
    }
    
    @State private var crown_selected: Float = 0
    
    @State private var crown_last_selected: Float = 0
    
    @State private var crown_timer: Timer? = nil
    
    @State private var crown_focus: Bool = true
    
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
#if os(macOS)
                    Button("-", action: {
                        DispatchQueue.main.async {
                            x_lim_add(step: self.x_lim_step)
                            y_lim_add(step: self.y_lim_step)
                        }
                    })
                    Spacer()
#endif
                    Button("Reset", action: {
                        DispatchQueue.main.async {
                            withAnimation{
                                self.x_lim = x_lim_default
                                self.y_lim = y_lim_default
                                self.canvasOffset = .zero
                                self.canvasOffset_last = .zero
                            }
                        }
                    })
#if os(macOS)
                    Spacer()
                    Button("+", action:{
                        DispatchQueue.main.async {
                            x_lim_add(step: -self.x_lim_step)
                            y_lim_add(step: -self.y_lim_step)
                        }
                    })
#endif
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
#if os(macOS) || os(iOS)
            .simultaneousGesture(MagnificationGesture()
                .onChanged { scaleValue in
                    guard scaleValue != 0 else{
                        return
                    }
                    
                    let delta_continuous: CGFloat = scaleValue > lastScale ? scaleValue / lastScale : -lastScale / scaleValue
                    let delta_discrete: CGFloat = CGFloat(Int(delta_continuous))
                    print(delta_continuous)
                    print(delta_discrete)
                    
                    if (delta_discrete - scale_cumulative).magnitude > 0{
                        let speed: CGFloat = delta_discrete - scale_cumulative < 0 ? 1 : -1
                        scale_lim(speed: speed)
                        scale_cumulative = delta_discrete
                    }
                }
                .onEnded { _ in
                    lastScale = 1.0
                    scale_cumulative = 0.0
                })
#endif
#if os(macOS)
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSApplication.willUpdateNotification, object: nil, queue: nil) { _ in
                    if let event = NSApp.currentEvent {
                        if event.type == .scrollWheel {
                            let speed: CGFloat = event.scrollingDeltaY < 0 ? 1 : -1
                            scale_lim(speed: speed)
                        }
                    }
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: NSApplication.willUpdateNotification, object: nil)
            }
#endif
#if os(watchOS)
            .focusable(self.crown_focus) // To receive focus for crown events.
            .digitalCrownRotation(detent: $crown_selected, from: -5.0, through: 5.0, by: 1.0, sensitivity: .low) { crownEvent in
//                print("crown_selected = \(crown_selected)")
//                print("offset = \(crownEvent.offset)")
                self.crown_timer = .scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                    self.crown_focus = false
                    DispatchQueue.main.async {
                        self.crown_focus = true
                    }
                }
                
                let crow_direction: CGFloat = crown_last_selected > crown_selected ? 1 : -1

                if crown_selected != crown_last_selected{
                    if crown_selected != 0{
                        scale_lim(speed: crow_direction)
                    }
                    
                    crown_last_selected = crown_selected
                }
            } onIdle: {
                self.crown_selected = 0
                self.crown_timer?.invalidate()
            }
#endif
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
