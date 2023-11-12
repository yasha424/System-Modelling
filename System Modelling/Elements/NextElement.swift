//
//  NextElement.swift
//  System Modelling
//
//  Created by yasha on 11.11.2023.
//

enum NextElementError: Error {
    case undefinedPriority
    case undefinedProbability
    case probabilitySumNotEqualToOne
}

class NextElement<T> {
    let element: Element<T>
    let priority: Int?
    let probability: Double?
    
    init(element: Element<T>, priority: Int? = nil, probability: Double? = nil) {
        self.element = element
        self.priority = priority
        self.probability = probability
    }
}
