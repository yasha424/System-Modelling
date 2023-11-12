//
//  Process.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

class Process<T>: Element<T> {
    var queue: [T?] = []
//    private var item: T
    private(set) var maxQueue: Int = 0
    private(set) var failure: Int = 0
    private(set) var meanQueue: Double = 0
    private(set) var channelsStates = [Int]()
    private(set) var channelsTNext = [Double]()
    private(set) var channelsItems = [T?]()
    private(set) var totalLoadTime: Double = 0
    
    init(delay: Double, name: String, maxQueue: Int, channels: UInt, chooseBy type: NextElementsChooseType) {
        self.maxQueue = maxQueue
        
        for _ in 0..<channels {
            channelsStates.append(0)
            channelsTNext.append(Double.greatestFiniteMagnitude)
            channelsItems.append(nil)
        }

        super.init(delay: delay, name: name, chooseBy: type)
    }
        
    override func inAct(_ item: T? = nil) {
        let delay = getDelay()

        if !channelsStates.isEmpty {
            if let availableChannel = channelsStates.firstIndex(where: { $0 == 0 }) {
                channelsStates[availableChannel] = 1
                channelsTNext[availableChannel] = tCurr + delay
                channelsItems[availableChannel] = item
                totalLoadTime += delay
                tNext = channelsTNext.min() ?? Double.greatestFiniteMagnitude
            } else {
                if queue.count < maxQueue {
                    queue.append(item)
                } else {
                    failure += 1
                }
            }
        } else if state == 0 {
            state = 1
            tNext = tCurr + delay
            totalLoadTime += delay
            self.item = item
        } else {
            if queue.count < maxQueue {
                queue.append(item)
            } else {
                failure += 1
            }
        }
    }
    
    override func outAct() {
        super.outAct()
        
        let delay = getDelay()
        var currItem: T? = nil
        if !channelsStates.isEmpty {
            if let currChannel = channelsTNext.firstIndex(where: { $0 == tCurr }) {
                channelsStates[currChannel] = 0
                channelsTNext[currChannel] = Double.greatestFiniteMagnitude
                currItem = channelsItems[currChannel]
                channelsItems[currChannel] = nil
                if queue.count > 0 {
                    channelsStates[currChannel] = 1
                    channelsTNext[currChannel] = tCurr + delay
                    channelsItems[currChannel] = queue.removeFirst()
                    totalLoadTime += delay
                }
                tNext = channelsTNext.min() ?? Double.greatestFiniteMagnitude
            }
        } else {
            tNext = Double.greatestFiniteMagnitude
            state = 0
            self.item = nil
            if queue.count > 0 {
                self.item = queue.removeFirst()
                state = 1
                tNext = tCurr + delay
                totalLoadTime += delay
            }
        }
        getNextElement()?.inAct(currItem)
    }
    
    override func printInfo() {
        super.printInfo()
        print("queue length = \(queue.count), failure = \(failure)")
    }
    
    override func doStatistics(delta: Double) {
        meanQueue += Double(queue.count) * delta
    }
    
    override func isFree() -> Bool {
        if !channelsStates.isEmpty {
            return channelsStates.contains(0) || queue.count < maxQueue ? true : false
        } else {
            return state == 0
        }
    }
}
