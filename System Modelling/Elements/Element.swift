//
//  Element.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

class ID {
    static private var id = -1
    
    static func getId() -> Int {
        id += 1
        return id
    }
}

class Element<T> {
    var name: String = ""
    var tNext: Double = Double.greatestFiniteMagnitude
    var delayMean: Double = 0
    var delayDev: Double = 0
    var distribution: Distribution = .exponential
    private(set) var quantity: Int = 0
    var tCurr: Double = 0
    var state: Int = 0
    var item: T? = nil
    var nextElements: [NextElement<T>]?
    let nextElementsChooseType: NextElementsChooseType
//    private(set) static var nextId: Int = 0
    private(set) var id: Int = 0
    
    
    init(chooseBy type: NextElementsChooseType) {
        nextElementsChooseType = type
        initWithDelay(1)
        name = "element\(id)"
    }
    
    init(delay: Double, name: String, chooseBy type: NextElementsChooseType) {
        nextElementsChooseType = type
        initWithDelay(delay)
        self.name = name
    }
    
    private func initWithDelay(_ delay: Double) {
        delayMean = delay
        id = ID.getId()
//        Element.nextId += 1
    }
    
    func inAct(_ item: T? = nil) {}
    
    func outAct() {
        quantity += 1
    }
    
    func getNextElement() -> Element? {
        return getNextElement(by: nextElementsChooseType)
    }
    
    func getNextElement(by type: NextElementsChooseType) -> Element? {
        do {
            switch type {
            case .priority:
                return try getNextElementByPriority()
            case .probability:
                return try getNextElementByProbability()
            case .byQueueLength:
                return getNextElementByQueueLength()
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func getNextElementByQueueLength() -> Element? {
        guard let nextElements = nextElements, nextElements.count > 0 else { return nil }
        
        let nextProcesses = nextElements.filter { $0.element is Process<T> }.map { $0.element as! Process<T> }
        
        if let freeProcess = nextProcesses.first(where: {
            $0.queue.count == 0 && ($0.channelsStates.contains(0))
        }) {
            return freeProcess
        }
        
        let sortedProcesses = nextProcesses.sorted(by: { $0.queue.count < $1.queue.count })
        
        return sortedProcesses.first
    }
    
    func getNextElementByPriority() throws -> Element? {
        guard let nextElements = nextElements, nextElements.count > 0 else { return nil }
        
        if nextElements.contains(where: { $0.priority == nil }) {
            throw NextElementError.undefinedPriority
        }
        
        let sortedElements = nextElements.sorted(by: { $0.priority! > $1.priority! })
        for element in sortedElements {
            if element.element.isFree() {
                return element.element
            }
        }
        
        return sortedElements.first?.element
    }
    
    func getNextElementByProbability() throws -> Element? {
        guard let nextElements = nextElements, nextElements.count > 0 else { return nil }
        
        if nextElements.contains(where: { $0.probability == nil }) {
            throw NextElementError.undefinedProbability
        } else if nextElements.reduce(0, { $0 + $1.probability! }) != 1 {
            throw NextElementError.probabilitySumNotEqualToOne
        }
        
        var sum = 0.0
        let randomValue = Double.random(in: 0...1)
        for nextElement in nextElements {
            sum += nextElement.probability!
            if randomValue <= sum {
                return nextElement.element
            }
        }
        
        return nil
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
    
    func isFree() -> Bool { return true }
}
