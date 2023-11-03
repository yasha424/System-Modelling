//
//  Model.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

import Foundation

class Model {
    private let elements: [Element]
    private(set) var tNext, tCurr: Double
//    var event: Int
    
    init(elements: [Element]) {
        self.elements = elements
        tNext = 0
//        event = 0
        tCurr = tNext
    }
    
    func simulate(forTime time: Double) {
        while tCurr < time {
            var nextEvent: Element?
            tNext = Double.greatestFiniteMagnitude
            for element in elements {
                if element.tNext < tNext {
                    tNext = element.tNext
                    nextEvent = element
                }
            }
            
            print("\nIt's time for event in \(nextEvent?.name ?? ""), time = \(tNext)")
            
            for element in elements {
                element.doStatistics(delta: tNext - tCurr)
            }
            tCurr = tNext
            for element in elements {
                element.tCurr = tCurr
            }
            nextEvent?.outAct()
            for element in elements {
                if element.tNext == tCurr {
                    element.outAct()
                }
            }
            printInfo()
        }
        printResult()
    }
    
    func printInfo() {
        for element in elements {
            element.printInfo()
        }
    }
    
    func printResult() {
        print("\n-------------RESULTS-------------")
        for element in elements {
            element.printResult()
            if let process = element as? Process {
                print("Mean length of queue = \(process.meanQueue / tCurr)" +
                      "\nFailure probability = \(Double(process.failure) / Double(process.quantity + process.failure))\n")
            }
        }
    }
}
