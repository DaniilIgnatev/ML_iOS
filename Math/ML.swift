//
//  LR.swift
//  LR
//
//  Created by Daniil Ignatev on 18.07.23.
//

import Foundation
import simd
import Accelerate

class ML: ObservableObject{    
    public static func ols_1(input: [Double], out: [Double]) -> Double{
        //((A.T@A)^-1)@A.T@y
        let A = LinAlg.init_simd32(data: input)
        let y = LinAlg.init_simd32(data: out)

        let AT = A
        let ATA = LinAlg.dot(AT, A)
        let ATA_inv = 1.0 / ATA
        
        let ATy = LinAlg.dot(AT, y)
        
        let result = ATA_inv * ATy
        
        return result
    }
}


public func softmax(x: [Double]) -> [Double]{
    let e_part = x.map({exp($0)})
    let sum = e_part.reduce(0, +)
    return e_part.map({$0 / sum})
}
