//
//  DefaultNeuralNetwork.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

public class NeuralNetwork {
    let layers: [NeuralNetworkLayer]
    
    public init(name: String, layers: [NeuralNetworkLayer]) {
        self.layers = layers
    }
    
    public init(name: String, hidden_layers_number: Int){
        let directory_path = "NN/\(name)"
        var layers = [NeuralNetworkLayer]()
        
        for i in 0..<hidden_layers_number + 1{
            let l = NeuralNetworkLayer.init(root_path: "\(directory_path)/layer_\(i)", index: i)
            layers.append(l)
        }
        
        self.layers = layers
    }
    
    func forwardPropagation(input: [Double]) throws -> [Double] {
        var dynamicInput = input
        
        try layers.forEach { layer in
            dynamicInput = try layer.forwardPropagation(input: dynamicInput)
            print(dynamicInput)
        }
        
        return dynamicInput
    }
}
