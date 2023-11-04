//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

import Foundation

func main() {
    let create = Create(delay: 2.0, name: "CREATOR")
    let process1 = Process(delay: 3, name: "PROCESSOR1", maxQueue: 5, channels: 3)
    let process2 = Process(delay: 1, name: "PROCESSOR2", maxQueue: 5, channels: 3)
    let process3 = Process(delay: 5, name: "PROCESSOR3", maxQueue: 5, channels: 3)
//    let process4 = Process(delay: 1, name: "PROCESSOR4", maxQueue: 5, channels: 3)


//    print("id0 = \(create.id), id1 = \(process.id)")
    
    create.distribution = .uniform
    process1.distribution = .uniform
    process2.distribution = .uniform
    process3.distribution = .uniform
    
    create.nextElements = [process1, process2, process3]
    process1.nextElements = [process2, process3]
    process2.nextElements = [process3]
//    process3.nextElements = [process1, process2, process4]
        
    let elements: [Element] = [create, process1, process2, process3]
    let model = Model(elements: elements)
    model.simulate(forTime: 100000)
}

main()
