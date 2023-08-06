//
//  Layer.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

protocol LayerProtocol {
    func forwardPropagation(input: [Double]) throws -> [Double]
}
