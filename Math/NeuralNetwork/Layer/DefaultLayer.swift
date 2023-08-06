//
//  DefaultLayer.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

class DefaultLayer: LayerProtocol {
    let neurons: [NeuronProtocol]
    let weights: [[Double]]
    let offsets: [Double]

    init(neurons: [NeuronProtocol], weights: [[Double]], offsets: [Double]) {
        self.neurons = neurons
        self.weights = weights
        self.offsets = offsets
    }

    func forwardPropagation(input: [Double]) throws -> [Double] {
//        guard input.count == neurons.count else {
//            throw LayerError.differentNumberOfNeuronsAndInputs
//        }

        neurons.enumerated().map { index, neuron in
            neuron.forwardPropagation(
                input: .init(
                    data: weights[index].enumerated().map { .init(value: input[$0], weight: $1) },
                    offset: offsets[index]
                )
            )
        }
    }
}
