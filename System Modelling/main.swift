//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

func task1() {
    let create = Create<Any>(delays: [.init(delayMean: 2, probability: 1)], name: "CREATOR", chooseBy: .priority)
    let process1 = Process<Any>(delay: 1, name: "PROCESSOR-1", maxQueue: 5, channels: 3, chooseBy: .probability)
    let process2 = Process<Any>(delay: 1, name: "PROCESSOR-2", maxQueue: 5, channels: 3, chooseBy: .priority)
    let process3 = Process<Any>(delay: 1, name: "PROCESSOR-3", maxQueue: 5, channels: 3, chooseBy: .probability)
    let process4 = Process<Any>(delay: 1, name: "PROCESSOR-4", maxQueue: 5, channels: 1, chooseBy: .priority)

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
    struct Client {}
    
    let clients = Create(delays: [.init(delayMean: 0.5, probability: 1, { Client() })], name: "Clients", chooseBy: .byQueueLength)
    
    let cashier1 = Process<Client>(delay: 1.0, name: "Cashier-1", maxQueue: 3, channels: 1, chooseBy: .priority)
    let cashier2 = Process<Client>(delay: 1.0, name: "Cashier-2", maxQueue: 3, channels: 1, chooseBy: .priority)
    
    clients.nextElements = [
        NextElement(element: cashier1),
        NextElement(element: cashier2)
    ]
    
    cashier1.distribution = .normal
    cashier1.delayDev = 0.3

    cashier2.distribution = .normal
    cashier2.delayDev = 0.3

    for _ in 1...3 {
        cashier1.inAct(Client())
        cashier2.inAct(Client())
    }
    
    cashier1.distribution = .exponential
    cashier1.delayMean = 0.3
    cashier2.distribution = .exponential
    cashier2.delayMean = 0.3
    
    clients.tNext = 0.1

    let model = Model(elements: [clients, cashier1, cashier2])
    model.simulate(forTime: 1000, swapDifference: 2)
}

func hospitalTask() {
    struct Patient {
        let type: Int
    }
    
    let patients = Create(delays: [
        .init(delayMean: 15, probability: 0.5, { return Patient(type: 1) })
//        .init(delayMean: 15, probability: 0.5, itemGenerator: { return Patient(type: 1) }),
//        .init(delayMean: 40, probability: 0.1, itemGenerator: { return Patient(type: 2) }),
//        .init(delayMean: 30, probability: 0.4, itemGenerator: { return Patient(type: 3) })
    ], name: "", chooseBy: .probability)
    
    
}

func main() {
    bankTask()
}

main()
