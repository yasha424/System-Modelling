//
//  Event.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

import Foundation

class Element {
    var name: String = ""
    var tNext: Double = 0
    var delayMean: Double = 0
    var delayDev: Double = 0
    var distribution: Distribution = .exponential
    private(set) var quantity: Int = 0
    var tCurr: Double = 0
    var state: Int = 0
    var nextElement: Element?
    private(set) static var nextId: Int = 0
    private(set) var id: Int = 0
    
    
    init() {
        initWithDelay(1)
    }
    
    init(delay: Double){
        initWithDelay(delay)
    }
    
    private func initWithDelay(_ delay: Double) {
        delayMean = delay
//        nextElement = nil
        id = Element.nextId
        Element.nextId += 1
        name = "element\(id)"
    }
    
    func inAct() {}
    
    func outAct() {
        quantity += 1
    }
    
    func getDelay() -> Double {
        switch distribution {
        case .exponential:
            return FunRand.exponential(timeMean: delayMean)
        case .normal:
            return FunRand.normal(timeMean: delayMean, timeDeviation: delayDev)
        case .uniform:
            return FunRand.uniform(timeMin: delayMean, timeMax: delayDev)
        }
    }
    
    func printResult() {
        print("\(name), quantity = \(quantity)")
    }

    func printInfo() {
        print("\(name), state = \(state), quantity = \(quantity), tNext = \(tNext)")
    }
    
    func doStatistics(delta: Double) {}
}
