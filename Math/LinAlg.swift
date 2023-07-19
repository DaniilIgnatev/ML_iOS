//
//  Math.swift
//  LR
//
//  Created by Daniil Ignatev on 18.07.23.
//

import Foundation
import simd

class LinAlg{
    internal static func dot(_ vector1: SIMD32<Double>,_ vector2: SIMD32<Double>) -> simd_double1{
        var dotProduct: Double = 0.0
        for i in 0..<SIMD32<Double>.scalarCount {
            dotProduct += vector1[i] * vector2[i]
        }
        
        return dotProduct
    }
    
    
    internal static func init_simd32(data: [Double]) -> SIMD32<Double>{
        var V = SIMD32<Double>.init(repeating: 0)
        for i in 0..<data.count{
            V[i] = data[i]
        }
        
        return V
    }
    
    func line(x1: [Double], w0: Double, w1: Double) -> [Double]{
        return x1.map { w0 * $0 + w1}
    }
}
