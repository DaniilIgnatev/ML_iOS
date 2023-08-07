//
//  DefaultNeuron.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

public class Neuron {
    let weights: [Double]
    let bias: Double
    
    init(weights: [Double], bias: Double) {
        self.weights = weights
        self.bias = bias
    }
    
    func forwardPropagation(input: [Double]) -> Double {
        var z = bias
        for i in 0..<input.count{
            z += weights[i] * input[i]
        }
        
        return self.activate(value: z)
    }
    
    private func activate(value: Double) -> Double {
        1 / (1 + 1 / pow(exp(1), value))
    }
}
