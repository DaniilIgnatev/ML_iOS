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

public struct Point: Identifiable{
    public let id: Int
    
    public init(x: Double, y: Double){
        self.id = counter
        self.x = x
        self.y = y
    }
    
    public init(_ point: CGPoint){
        self.id = counter
        self.x = point.x
        self.y = point.y
    }
    
    public let x: CGFloat
    
    public let y: CGFloat
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
