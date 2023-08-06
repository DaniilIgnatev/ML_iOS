//
//  ForwardPropagation.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

protocol NeuralNetworkProtocol {
    func forwardPropagation(input: [Double]) throws -> [Double]
}
