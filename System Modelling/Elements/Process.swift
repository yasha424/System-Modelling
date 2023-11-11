//
//  Process.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

class Process: Element {
    private(set) var queue: Int = 0
    private(set) var maxQueue: Int = 0
    private(set) var failure: Int = 0
    private(set) var meanQueue: Double = 0
    private(set) var channelsStates = [Int]()
    private(set) var channelsTNext = [Double]()
    private(set) var totalLoadTime: Double = 0
    
    init(delay: Double, name: String, maxQueue: Int, channels: UInt, chooseBy type: NextElementsChooseType) {
        self.maxQueue = maxQueue
        
        for _ in 0..<channels {
            channelsStates.append(0)
            channelsTNext.append(Double.greatestFiniteMagnitude)
        }

        super.init(delay: delay, name: name, chooseBy: type)
    }
        
    override func inAct() {
        let delay = getDelay()

        if !channelsStates.isEmpty {
            if let availableChannel = channelsStates.firstIndex(where: { $0 == 0 }) {
                channelsStates[availableChannel] = 1
                channelsTNext[availableChannel] = tCurr + delay
                totalLoadTime += delay
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
            tNext = tCurr + delay
            totalLoadTime += delay
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
        
        let delay = getDelay()
        if !channelsStates.isEmpty {
            if let currChannel = channelsTNext.firstIndex(where: { $0 == tCurr }) {
                channelsStates[currChannel] = 0
                channelsTNext[currChannel] = Double.greatestFiniteMagnitude
                if queue > 0 {
                    queue -= 1
                    channelsStates[currChannel] = 1
                    channelsTNext[currChannel] = tCurr + delay
                    totalLoadTime += delay
                }
                tNext = channelsTNext.min() ?? Double.greatestFiniteMagnitude
            }
        } else {
            tNext = Double.greatestFiniteMagnitude
            state = 0
            if queue > 0 {
                queue -= 1
                state = 1
                tNext = tCurr + delay
                totalLoadTime += delay
            }
        }
        getNextElement()?.inAct()
    }
    
    override func printInfo() {
        super.printInfo()
        print("failure = \(failure)")
    }
    
    override func doStatistics(delta: Double) {
        meanQueue += Double(queue) * delta
    }
    
    override func isFree() -> Bool {
        if !channelsStates.isEmpty {
            return channelsStates.contains(0) ? true : false
        } else {
            return state == 0
        }
    }
}
