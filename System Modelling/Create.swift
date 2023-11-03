//
//  ProcessEvent.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

import Foundation

class Create: Element {
    override init(delay: Double) {
        super.init(delay: delay)
        self.tNext = 0
    }
    
    override func outAct() {
        super.outAct()
        self.tNext = tCurr + getDelay()
        nextElement?.inAct()
    }
}
