//
//  DefaultNeuron.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

class DefaultNeuron: NeuronProtocol {
    private let activationFunction: ActivationFunctionProtocol
    private let method: NeuronMethodProtocol

    init(activationFunction: ActivationFunctionProtocol, method: NeuronMethodProtocol) {
        self.activationFunction = activationFunction
        self.method = method
    }

    func forwardPropagation(input: NeuronInput) -> Double {
        let sum = input.data.reduce(Double(0)) { partialResult, nextInput in
            partialResult + method.calculate(value: nextInput.value, weight: nextInput.weight)
        }

        return activationFunction.activate(value: sum + input.offset)
    }
}
