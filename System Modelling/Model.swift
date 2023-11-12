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
    private var swapCount: Int = 0
    
    init(elements: [Element]) {
        self.elements = elements
        tNext = 0
        tCurr = tNext
    }
    
    func simulate(forTime time: Double, swapDifference: Int? = nil) {
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

            if let swapDifference = swapDifference {
                tryToSwapQueue(swapDifference)
            }

            printInfo()
        }
        printResult()
    }
    
    func tryToSwapQueue(_ swapDifference: Int) {
        let processes = elements.filter { $0 is Process }.map { $0 as! Process }
        
        for process in processes {
            for anotherProcess in processes {
                if anotherProcess.name == process.name { continue }
                if process.queue - anotherProcess.queue >= 2 {
                    print("Swaped item from \(process.name) to \(anotherProcess.name)")
                    swapCount += 1
                    process.queue -= 1
                    anotherProcess.queue += 1
                }
            }
        }
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
                      "\nFailure probability = \(Double(process.failure) / Double(process.quantity + process.failure))" +
                      "\nFailure = \(process.failure)" +
                      "\nMean load time = \(process.totalLoadTime / tCurr)")
            }
            print()
        }
        
        print("Mean clients count in bank = \(getMeanClientsCountInBank())" +
              "\nMean time between leaving = \(getMeanTimeBetweenLeaving())" +
              "\nMean client time in bank = \(getMeanClientsTimeInBank())" +
              "\nFailure probabilty in bank = \(getFailureProbabilityInBank())" +
              "\nSwaps count = \(swapCount)"
        )
//        writeToCsv()
    }
    
    func getMeanClientsCountInBank() -> Double {
        return elements.filter { $0 is Process }.map { $0 as! Process }.reduce(0) { partialResult, process in
//            let meanClients = process.totalLoadTime / Double(process.quantity)
            return partialResult + (process.meanQueue + process.totalLoadTime) / tCurr
        }
    }
    
    func getMeanTimeBetweenLeaving() -> Double {
        let processes = elements.filter { $0 is Process }.map { $0 as! Process }
        return tCurr / processes.reduce(0) { partialResult, process in
            return partialResult + Double(process.quantity)
        }
    }
    
    func getMeanClientsTimeInBank() -> Double {
        let processes = elements.filter { $0 is Process }.map { $0 as! Process }
        let totalClientsTimeInBank = processes.reduce(0) { partialResult, process in
            return partialResult + process.totalLoadTime + process.meanQueue
        }
        return totalClientsTimeInBank / processes.reduce(0) { $0 + Double($1.quantity) }
    }
    
    func getFailureProbabilityInBank() -> Double {
        let processes = elements.filter { $0 is Process }.map { $0 as! Process }
        
        let sumOfFailureProbability = processes.reduce(0) {
            $0 + Double($1.failure) / Double($1.quantity + $1.failure)
        }
        return sumOfFailureProbability / Double(processes.count)
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
