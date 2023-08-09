//
//  LinearRegression.swift
//  ML
//
//  Created by Daniil Ignatev on 09.08.23.
//

import Foundation
import Math

class LinearRegression {
    public static func ols_1(input: [Double], out: [Double]) -> Double{
        //((A.T@A)^-1)@A.T@y
        let A = Num.init_simd32(data: input)
        let y = Num.init_simd32(data: out)

        let AT = A
        let ATA = Num.dot(AT, A)
        let ATA_inv = 1.0 / ATA
        
        let ATy = Num.dot(AT, y)
        
        let result = ATA_inv * ATy
        
        return result
    }
}
