//
//  Process.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

import Foundation

class Process: Element {
    var queue, maxQueue, failure: Int
    private(set) var meanQueue: Double
    
    override init(delay: Double) {
        queue = 0
        maxQueue = Int.max
        failure = 0
        meanQueue = 0
        
        super.init(delay: delay)
    }
    
    override func inAct() {
        if state == 0 {
            state = 1
            tNext = tCurr + getDelay()
        } else {
            if queue < maxQueue {
                queue += 1
            } else {
                failure += 1
            }
        }
    }
    
    override func outAct() {
        super.outAct()
        tNext = Double.greatestFiniteMagnitude
        state = 0
        if queue > 0 {
            queue -= 1
            state = 1
            tNext = tCurr + getDelay()
        }
        nextElement?.inAct()
    }
    
    override func printInfo() {
        super.printInfo()
        print("failure = \(failure)")
    }
    
    override func doStatistics(delta: Double) {
        meanQueue += Double(queue) * delta
    }
}
