//
//  Math.swift
//  LR
//
//  Created by Daniil Ignatev on 18.07.23.
//

import Foundation
import simd

public class Num {
    public static func softmax(x: [Double]) -> [Double]{
        let e_part = x.map({exp($0)})
        let sum = e_part.reduce(0, +)
        return e_part.map({$0 / sum})
    }
    
    public static func dot(_ vector1: SIMD32<Double>,_ vector2: SIMD32<Double>) -> simd_double1{
        var dotProduct: Double = 0.0
        for i in 0..<SIMD32<Double>.scalarCount {
            dotProduct += vector1[i] * vector2[i]
        }
        
        return dotProduct
    }
    
    
    public static func init_simd32(data: [Double]) -> SIMD32<Double>{
        var V = SIMD32<Double>.init(repeating: 0)
        for i in 0..<data.count{
            V[i] = data[i]
        }
        
        return V
    }
    
    public func line(x1: [Double], w0: Double, w1: Double) -> [Double]{
        return x1.map { w0 * $0 + w1}
    }
    
    public static func readFile(_ name: String,_ type: String,_ directory: String) -> String?{
        let bundle = Bundle(for: Num.self)

        guard let filePath = bundle.path(forResource: name, ofType: type, inDirectory: directory) else {
            print("File \(name).\(type) in \(directory) not found")
            return nil
        }
        
        return try? String(contentsOfFile: filePath, encoding: .utf8)
    }
    
    public static func readMatrix(name: String, type: String, directory: String) -> [[Double]] {
        guard let content = readFile(name, type, directory) else{
            return []
        }
        
        let lines = content.components(separatedBy: .newlines)
        
        return lines.compactMap { line in
            guard line != "" else {
                return nil
            }
            return line.split(separator: " ").compactMap { Double($0) }
        }
    }
    
    public static func readArray(name: String, type: String, directory: String) -> [Double] {
        guard let content = readFile(name, type, directory) else{
            return []
        }
        
        let lines = content.components(separatedBy: .newlines)
        
        return lines.compactMap { line in
            return Double(line)
        }
    }
    
    public static func truncateDouble(value: Double, toDecimalPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return Double(Int(value * multiplier)) / multiplier
    }
}
