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
    private(set) var channelsStates = [Int]()
    private(set) var channelsTNext = [Double]()
    
    init(delay: Double, name: String, maxQueue: Int, channels: Int) {
        self.queue = 0
        self.failure = 0
        self.meanQueue = 0
        self.maxQueue = maxQueue
        
        for _ in 0..<channels {
            channelsStates.append(0)
            channelsTNext.append(Double.greatestFiniteMagnitude)
        }

        super.init(delay: delay, name: name)
    }
        
    override func inAct() {
        if !channelsStates.isEmpty {
            if let availableChannel = channelsStates.firstIndex(where: { $0 == 0 }) {
                channelsStates[availableChannel] = 1
                channelsTNext[availableChannel] = tCurr + getDelay()
                tNext = channelsTNext.min() ?? Double.greatestFiniteMagnitude
            } else {
                if queue < maxQueue {
                    queue += 1
                } else {
                    failure += 1
                }
            }
        } else if state == 0 {
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
        
        if !channelsStates.isEmpty {
            if let currChannel = channelsTNext.firstIndex(where: { $0 == tCurr }) {
                channelsStates[currChannel] = 0
                channelsTNext[currChannel] = Double.greatestFiniteMagnitude
//                tNext = channelsTNext.min() ?? Double.greatestFiniteMagnitude
                if queue > 0 {
                    queue -= 1
                    channelsStates[currChannel] = 1
                    channelsTNext[currChannel] = tCurr + getDelay()
                }
                tNext = channelsTNext.min() ?? Double.greatestFiniteMagnitude
            }
        } else {
            tNext = Double.greatestFiniteMagnitude
            state = 0
            if queue > 0 {
                queue -= 1
                state = 1
                tNext = tCurr + getDelay()
            }
        }
        getNextElement()?.inAct()
//        nextElement?.inAct()
    }
    
    override func printInfo() {
        super.printInfo()
        print("failure = \(failure)")
    }
    
    override func doStatistics(delta: Double) {
        meanQueue += Double(queue) * delta
    }
}
