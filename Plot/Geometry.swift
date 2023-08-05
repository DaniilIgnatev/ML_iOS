//
//  Geometry.swift
//  ML_iOS
//
//  Created by Daniil Ignatev on 19.07.23.
//

import Foundation

fileprivate var _counter: Int = 0

fileprivate var counter: Int{
    _counter += 1
    return _counter
}

public struct Point: Identifiable, Hashable{
    public let id: Int
    
    public init(x: Double, y: Double){
        self.id = counter
        self.x = x
        self.y = y
    }
    
    public init(x: Int, y: Int){
        self.id = counter
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }
    
    public init(_ point: CGPoint){
        self.id = counter
        self.x = point.x
        self.y = point.y
    }
    
    public let x: CGFloat
    
    public let y: CGFloat
    
    public var point: CGPoint{
        return .init(x: self.x, y: self.y)
    }
    
    public func shiftBy(x: CGFloat, y: CGFloat) -> Point {
        return Point(x: self.x + x, y: self.y + y)
    }

    public func scalePoint(xFactor: CGFloat, yFactor: CGFloat) -> Point {
        return Point(x: Int(self.x * xFactor), y: Int(self.y * yFactor))
    }
    
    public static func linear_interpolation(p1: Point, p2: Point) -> Point{
        let x1 = p1.x
        let y1 = p1.y
        
        let x2 = p2.x
        let y2 = p2.y
        
        let x = (x2 + x1) / 2
        let y = (y2 + y1) / 2
        return Point(x: x, y: y)
    }
}

public struct Line: Identifiable{
    public let id: Int
    
    public init(w0: Double, w1: Double){
        self.id = counter
        self.w0 = w0
        self.w1 = w1
    }
    
    public let w0: Double
    
    public let w1: Double
}
