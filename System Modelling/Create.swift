//
//  Create.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

class Create: Element {
    
    override init(delay: Double, name: String) {
        super.init(delay: delay, name: name)
        self.tNext = 0
    }
    
    override func outAct() {
        super.outAct()
        self.tNext = tCurr + getDelay()
        getNextElement()?.inAct()
    }
}
