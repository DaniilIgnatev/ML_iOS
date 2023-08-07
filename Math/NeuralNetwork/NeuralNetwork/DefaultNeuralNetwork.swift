//
//  DefaultNeuralNetwork.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

class DefaultNeuralNetwork: NeuralNetworkProtocol {
    let layers: [LayerProtocol]

    init(layers: [LayerProtocol]) {
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
