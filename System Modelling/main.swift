//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

func main() {
    let create = Create(delay: 2, name: "CREATOR")
    let process1 = Process(delay: 6, name: "PROCESSOR-1", maxQueue: 5, channels: 5)
    let process2 = Process(delay: 6, name: "PROCESSOR-2", maxQueue: 5, channels: 3)
    let process3 = Process(delay: 6, name: "PROCESSOR-3", maxQueue: 5, channels: 3)
    let process4 = Process(delay: 6, name: "PROCESSOR-4", maxQueue: 5, channels: 3)

    create.nextElements = [process1]
    process1.nextElements = [process2]
    process2.nextElements = [process3]
    process3.nextElements = [process4]

    let model = Model(elements: [create, process1, process2, process3])
    model.simulate(forTime: 1000)
}

main()
