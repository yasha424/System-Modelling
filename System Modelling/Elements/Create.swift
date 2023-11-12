//
//  Create.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

class Create: Element {
    
    override init(delay: Double, name: String, chooseBy type: NextElementsChooseType) {
        super.init(delay: delay, name: name, chooseBy: type)
        self.tNext = 0
    }
    
    override func outAct(delay: Double? = nil) {
        super.outAct()
        self.tNext = tCurr + (delay == nil ? getDelay() : delay!)
        getNextElement()?.inAct()
    }
}
