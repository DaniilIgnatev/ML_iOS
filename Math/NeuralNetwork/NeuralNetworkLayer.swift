//
//  DefaultLayer.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

public class NeuralNetworkLayer {
    let index: Int
    let neurons: [Neuron]
    
    init(index: Int, weights: [[Double]], biases: [Double]) {
        self.index = index
        self.neurons = NeuralNetworkLayer.initNeurons(weights: weights, biases: biases)
    }
    
    init(root_path: String, index: Int){
        self.index = index
        
        let W = LinAlg.readMatrix(name: "W", type: "txt", directory: root_path)
        let B = LinAlg.readArray(name: "B", type: "txt", directory: root_path)
        
        self.neurons = NeuralNetworkLayer.initNeurons(weights: W, biases: B)
    }
    
    static func initNeurons(weights: [[Double]], biases: [Double]) -> [Neuron]{
        var neurons = [Neuron]()
        
        for i in 0..<biases.count{
            let neuron = Neuron(weights: weights[i], bias: biases[i])
            neurons.append(neuron)
        }
        
        return neurons
    }
    
    func forwardPropagation(input: [Double]) throws -> [Double] {
        var outputs = [Double]()
        
        for n in self.neurons{
            let output = n.forwardPropagation(input: input)
            outputs.append(output)
        }
        
        return outputs
    }
}
