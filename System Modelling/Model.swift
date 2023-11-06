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
    private static var csvString = ""
    
    init(elements: [Element]) {
        self.elements = elements
        tNext = 0
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
            
            if let event = nextEvent {
                print("\nIt's time for event in \(event.name), time = \(tNext)")
            }
                        
            for element in elements {
                element.doStatistics(delta: tNext - tCurr)
            }
            
            tCurr = tNext
            for element in elements {
                element.tCurr = tCurr
            }
            
            for element in elements {
                if element.tNext == tCurr {
                    element.outAct()
                }
            }
            printInfo()
        }
        printResult(time: time)
    }
    
    func printInfo() {
        for element in elements {
            element.printInfo()
        }
    }
    
    func printResult(time: Double) {
        print("\n-------------RESULTS-------------")
        for element in elements {
            element.printResult()
            if let process = element as? Process {
                print("Mean length of queue = \(process.meanQueue / tCurr)" +
                      "\nFailure probability = \(Double(process.failure) / Double(process.quantity + process.failure))" +
                      "\nFailure = \(process.failure)" +
                      "\nMean load time = \(process.totalLoadTime / time)")
            }
            print()
        }
//        writeToCsv()
    }
    
    func writeToCsv() {
        let fileManager = FileManager.default

        do {
            let path = try fileManager.url(for: .downloadsDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            let fileURL = path.appendingPathComponent("results.csv")
            
            for element in elements {
                Model.csvString += "\(element.delayMean),"
            }
            for element in elements {
                if let process = element as? Process {
                    Model.csvString += "\(process.maxQueue),"
                }
            }
            for element in elements {
                Model.csvString += "\(element.quantity),"
                if let process = element as? Process {
                    Model.csvString += "\(Double(process.failure) / Double(process.failure + process.quantity)),\(process.meanQueue / tCurr),"
                }
            }
            Model.csvString.removeLast()
            Model.csvString += "\n"

            try Model.csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {}
    }
}
