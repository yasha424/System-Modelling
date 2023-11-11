//
//  NextElement.swift
//  System Modelling
//
//  Created by yasha on 11.11.2023.
//

class NextElement {
    let element: Element
    let priority: Int?
    let probability: Double?
    
    init(element: Element, priority: Int? = nil, probability: Double? = nil) {
        self.element = element
        self.priority = priority
        self.probability = probability
    }
}
