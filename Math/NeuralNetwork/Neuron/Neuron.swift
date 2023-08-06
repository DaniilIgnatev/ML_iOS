//
//  Neuron.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

protocol NeuronProtocol {
    func forwardPropagation(input: NeuronInput) -> Double
}
