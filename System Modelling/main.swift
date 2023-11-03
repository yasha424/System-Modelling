//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

import Foundation

func main() {
    let create = Create(delay: 2.0)
    let process1 = Process(delay: 1)
    let process2 = Process(delay: 1)
    let process3 = Process(delay: 1)

//    print("id0 = \(create.id), id1 = \(process.id)")
    
    create.nextElement = process1
    process1.nextElement = process2
    process2.nextElement = process3
    
    process1.maxQueue = 5
    process2.maxQueue = 5
    process3.maxQueue = 5
    
    create.name = "CREATOR"
    process1.name = "PROCESSOR1"
    process2.name = "PROCESSOR2"
    process3.name = "PROCESSOR3"
    
    let elements: [Element] = [create, process1, process2, process3]
    let model = Model(elements: elements)
    model.simulate(forTime: 1000)
}

main()
