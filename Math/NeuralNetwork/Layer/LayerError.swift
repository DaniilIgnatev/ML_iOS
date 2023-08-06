//
//  LayerError.swift
//  Math
//
//  Created by Daniil on 05.08.2023.
//

import Foundation

enum LayerError: Error {
    case differentNumberOfNeuronsAndInputs
    
    var localizedDescription: String {
        switch self {
        case .differentNumberOfNeuronsAndInputs:
            return "Разное количество нейронов и входов"
        }
    }
}
