//
//  Element.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

class Element {
    var name: String = ""
    var tNext: Double = Double.greatestFiniteMagnitude
    var delayMean: Double = 0
    var delayDev: Double = 0
    var distribution: Distribution = .exponential
    private(set) var quantity: Int = 0
    var tCurr: Double = 0
    var state: Int = 0
    var nextElements: [NextElement]?
    let nextElementsChooseType: NextElementsChooseType
    private(set) static var nextId: Int = 0
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
        id = Element.nextId
        Element.nextId += 1
    }
    
    func inAct() {}
    
    func outAct() {
        quantity += 1
    }
    
    func getNextElement() -> Element? {
        return getNextElement(by: nextElementsChooseType)
//
//        if let nextElements = nextElements {
//            return nextElements[Int.random(in: 0..<nextElements.count)].element
//        } else {
//            return nil
//        }
    }
    
    func getNextElement(by type: NextElementsChooseType) -> Element? {
        switch type {
        case .priority:
            return getNextElementByPriority()
        case .probability:
            return getNextElementByProbability()
        }
    }
    
    func getNextElementByPriority() -> Element? {
        guard let nextElements = nextElements, nextElements.count > 0,
              !nextElements.contains(where: { $0.priority == nil }) else { return nil }
        
        let sortedElements = nextElements.sorted(by: { $0.priority! > $1.priority! })
        for element in sortedElements {
            if element.element.isFree() {
                return element.element
            }
        }
        
        return sortedElements.first?.element
    }
    
    func getNextElementByProbability() -> Element? {
        guard let nextElements = nextElements, nextElements.count > 0,
              !nextElements.contains(where: { $0.probability == nil }),
              nextElements.reduce(0, { $0 + $1.probability! }) == 1 else { return nil }
        
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
    
    func isFree() -> Bool { return false }
}
