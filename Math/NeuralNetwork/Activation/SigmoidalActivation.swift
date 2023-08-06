//
//  SigmoidalActivation.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

class SigmoidalActivation: ActivationFunctionProtocol {
    func activate(value: Double) -> Double {
        1 / (1 + 1 / pow(exp(1), value))
    }
}
