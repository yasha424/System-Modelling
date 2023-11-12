//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

func task1() {
    let create = Create(delay: 2, name: "CREATOR", chooseBy: .priority)
    let process1 = Process(delay: 1, name: "PROCESSOR-1", maxQueue: 5, channels: 3, chooseBy: .probability)
    let process2 = Process(delay: 1, name: "PROCESSOR-2", maxQueue: 5, channels: 3, chooseBy: .priority)
    let process3 = Process(delay: 1, name: "PROCESSOR-3", maxQueue: 5, channels: 3, chooseBy: .probability)
    let process4 = Process(delay: 1, name: "PROCESSOR-4", maxQueue: 5, channels: 1, chooseBy: .priority)

    create.nextElements = [NextElement(element: process1, priority: 1)]
    process1.nextElements = [
        NextElement(element: process2, probability: 0.8),
        NextElement(element: process3, probability: 0.1),
        NextElement(element: process4, probability: 0.1),
    ]
    process2.nextElements = [
//        NextElement(element: process1, priority: 1),
        NextElement(element: process3, priority: 3),
        NextElement(element: process4, priority: 2),
    ]
    process3.nextElements = [
        NextElement(element: process1, probability: 0.0),
        NextElement(element: process2, probability: 0.0),
        NextElement(element: process4, probability: 1.0),
    ]

    let model = Model(elements: [create, process1, process2, process3])
    model.simulate(forTime: 1000)
}

func bankTask() {
    let clients = Create(delay: 0.5, name: "Clients", chooseBy: .byQueueLength)
    
    let cashier1 = Process(delay: 1.0, name: "Cashier-1", maxQueue: 3, channels: 1, chooseBy: .priority)
    let cashier2 = Process(delay: 1.0, name: "Cashier-2", maxQueue: 3, channels: 1, chooseBy: .priority)
    
    clients.nextElements = [
        NextElement(element: cashier1, priority: 2),
        NextElement(element: cashier2, priority: 1)
    ]
    
    cashier1.distribution = .normal
    cashier1.delayDev = 0.3
//    cashier1.inAct()

    cashier2.distribution = .normal
    cashier2.delayDev = 0.3
//    cashier2.inAct()
    for _ in 1...3 {
        cashier1.inAct()
        cashier2.inAct()
    }
    
    cashier1.distribution = .exponential
    cashier1.delayMean = 0.3
    cashier2.distribution = .exponential
    cashier2.delayMean = 0.3
    
//    clients.tNext = 0.1
    clients.outAct(delay: 0.1)
    
    let model = Model(elements: [clients, cashier1, cashier2])
    model.simulate(forTime: 1000)
}

func main() {
    bankTask()
}

main()
