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
        
        var neurons = [Neuron]()
        
        let W = LinAlg.readMatrix(name: "W_\(self.index)", type: "txt", directory: root_path)
        let B = LinAlg.readArray(name: "B_\(self.index)", type: "txt", directory: root_path)
        let neurons_number = B.count
        
        for i in 0..<neurons_number{
            let neuron = Neuron.init(weights: W[i], bias: B[i])
            neurons.append(neuron)
        }
        self.neurons = neurons
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
