//
//  MultiplicationMethod.swift
//  Math
//
//  Created by Daniil on 06.08.2023.
//

import Foundation

class MultiplicationMethod: NeuronMethodProtocol {
    func calculate(value: Double, weight: Double) -> Double {
        value * weight
    }
}
