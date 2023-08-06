//
//  MathTests.swift
//  MathTests
//
//  Created by Daniil Ignatev on 19.07.23.
//

import XCTest
@testable import Math

class MathTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testNeuron() throws {
        let outputs: [NeuronData] = [NeuronData(value: 0.1, weight: 25), NeuronData(value: -3, weight: 4)]
        let neuron: NeuronProtocol = DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod())
        let result = neuron.forwardPropagation(input: .init(data: outputs, offset: 10))
        
        let expectedResult: Double = 0.62245933.roundToThousands()
        let finalResult: Double = result.roundToThousands()
        
        XCTAssertEqual(finalResult, expectedResult)
    }

    func testLayer() throws {
        let neurons: [NeuronProtocol] = [
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod())
        ]
        let layerInput: [Double] = [0.4, 0.6]
        
        let layer: LayerProtocol = DefaultLayer(
            neurons: neurons,
            weights: [
                [1, 1.1],
                [1.2, 1.3],
                [1.4, 1.5],
                [1.6, 1.7]
            ],
            offsets: [0.5, 0.2, 0.3, 0.6]
        )
        let result = try! layer.forwardPropagation(input: layerInput).map { $0.roundToThousands() }
        
        let expectedResult: [Double] = [
            0.82635335,
            0.81153267,
            0.85320966,
            0.90550963
        ].map { $0.roundToThousands() }
        
        XCTAssertEqual(result, expectedResult)
    }

    func testNetwork() throws {
        // MARK: First hidden layer
        
        let firstLayerNeurons: [NeuronProtocol] = [
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod())
        ]
        let firstLayer: LayerProtocol = DefaultLayer(
            neurons: firstLayerNeurons,
            weights: [
                [1, 1.1],
                [1.2, 1.3],
                [1.4, 1.5],
                [1.6, 1.7]
            ],
            offsets: [0.5, 0.2, 0.3, 0.6]
        )
        
        // MARK: Second hidden layer
        
        let secondLayerNeurons: [NeuronProtocol] = [
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod()),
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod())
        ]
        let secondLayer: LayerProtocol = DefaultLayer(
            neurons: secondLayerNeurons,
            weights: [
                [2.1, 1.8, 1.5, 1.2],
                [2.0, 1.7, 1.4, 1.1],
                [1.9, 1.6, 1.3, 1.0]
            ],
            offsets: [0.7, 0.1, 0.4]
        )
        
        // MARK: Third hidden layer
        
        let thirdLayerNeurons: [NeuronProtocol] = [
            DefaultNeuron(activationFunction: SigmoidalActivation(), method: MultiplicationMethod())
        ]
        let thirdLayer: LayerProtocol = DefaultLayer(
            neurons: thirdLayerNeurons,
            weights: [
                [1.0, 1.1, 1.2]
            ],
            offsets: [0.8]
        )
        
        // MARK: Neural network
        
        let layers = [firstLayer, secondLayer, thirdLayer]
        
        let neuralNetwork: NeuralNetworkProtocol = DefaultNeuralNetwork(layers: layers)
        
        let result = try neuralNetwork.forwardPropagation(input: [0.4, 0.6]).map { $0.roundToThousands() }

        let expectedResult: [Double] = [
            0.98348277
        ].map { $0.roundToThousands() }
        
        XCTAssertEqual(result, expectedResult)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

private extension Double {
    func roundToThousands() -> Double {
        (self * 1000).rounded() / 1000
    }
}
