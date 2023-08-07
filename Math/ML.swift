//
//  LR.swift
//  LR
//
//  Created by Daniil Ignatev on 18.07.23.
//

import Foundation
import simd

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
