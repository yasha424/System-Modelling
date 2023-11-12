//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

func task1() {
    let create = Create<Any>(delays: [.init(delayMean: 2, probability: 1)], name: "CREATOR", chooseBy: .priority)
    let process1 = Process<Any>(name: "PROCESSOR-1", maxQueue: 5, channels: 3, chooseBy: .probability) { _ in
        FunRand.exponential(timeMean: 1)
    }
    let process2 = Process<Any>(name: "PROCESSOR-2", maxQueue: 5, channels: 3, chooseBy: .priority) { _ in
        FunRand.exponential(timeMean: 1)
    }
    let process3 = Process<Any>(name: "PROCESSOR-3", maxQueue: 5, channels: 3, chooseBy: .probability) { _ in
        FunRand.exponential(timeMean: 1)
    }
    let process4 = Process<Any>(name: "PROCESSOR-4", maxQueue: 5, channels: 1, chooseBy: .priority) { _ in
        FunRand.exponential(timeMean: 1)
    }

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
    
    let cashier1 = Process<Client>(name: "Cashier-1", maxQueue: 3, channels: 1, chooseBy: .priority) { _ in
        FunRand.normal(timeMean: 1, timeDeviation: 0.3)
    }
    let cashier2 = Process<Client>(name: "Cashier-2", maxQueue: 3, channels: 1, chooseBy: .priority) { _ in
        FunRand.normal(timeMean: 1, timeDeviation: 0.3)
    }
    
    clients.nextElements = [
        NextElement(element: cashier1),
        NextElement(element: cashier2)
    ]
    
    for _ in 1...3 {
        cashier1.inAct(Client())
        cashier2.inAct(Client())
    }
    
    cashier1.getDelay = { _ in
        FunRand.exponential(timeMean: 0.3)
    }
    cashier2.getDelay = { _ in
        FunRand.exponential(timeMean: 0.3)
    }
    
    clients.tNext = 0.1

    let model = Model(elements: [clients, cashier1, cashier2])
    model.simulate(forTime: 1000, swapDifference: 2)
}

func hospitalTask() {
    struct Patient {
        let type: Int
    }
    
    
    let patients = Create(delays: [
        .init(delayMean: 15, probability: 0.5, { Patient(type: 1) }),
        .init(delayMean: 15, probability: 0.1, { Patient(type: 2) }),
        .init(delayMean: 15, probability: 0.4, { Patient(type: 3) })
    ], name: "Patients", chooseBy: .probability)

    let registration = Process<Patient>(
        name: "Registration",
        maxQueue: Int.max,
        channels: 2,
        chooseBy: .byCondition
    ) { patient in
        if let patient = patient {
            switch patient.type {
            case 1:
                return FunRand.constant(15)
            case 2:
                return FunRand.constant(15)
            case 3:
                return FunRand.constant(15)
            default:
                return Double.greatestFiniteMagnitude
            }
        }
        return Double.greatestFiniteMagnitude
    }
    
    let goingToWards = Process<Patient>(
        name: "Going to Wards",
        maxQueue: Int.max,
        channels: 3,
        chooseBy: .probability
    ) { _ in
        FunRand.uniform(timeMin: 3, timeMax: 8)
    }

    let goingToLab = Process<Patient>(
        name: "Going to Laboratory",
        maxQueue: Int.max,
        channels: 1000,
        chooseBy: .probability
    ) { _ in
        FunRand.uniform(timeMin: 2, timeMax: 5)
    }

    let labRegistration = Process<Patient>(
        name: "Laboratory Registration",
        maxQueue: Int.max,
        channels: 1,
        chooseBy: .probability
    ) { _ in
        FunRand.erlang(timeMean: 4.5, k: 3)
    }
    
    let analysis = Process<Patient>(
        name: "Analysis",
        maxQueue: Int.max,
        channels: 2,
        chooseBy: .probability
    ) { _ in
        FunRand.erlang(timeMean: 4, k: 2)
    }
    
    let dispose = Process<Patient>(
        name: "Dispose",
        maxQueue: Int.max,
        channels: 1,
        chooseBy: .probability
    ) { _ in return 0 }
    
    patients.nextElements = [.init(element: registration, probability: 1)]
    
    registration.nextElements = [
        .init(element: goingToWards) { $0.type == 1 },
        .init(element: goingToLab) { $0.type != 1 }
    ]
    
    goingToWards.nextElements = [.init(element: dispose, probability: 1)]
    
    goingToLab.nextElements = [.init(element: labRegistration, probability: 1)]
    
    labRegistration.nextElements = [.init(element: analysis, probability: 1)]
    
    analysis.nextElements = [
        .init(element: registration, probability: 0.5, itemGenerator: { Patient(type: 1) }),
        .init(element: dispose, probability: 0.5)
    ]
            
    let model = Model(elements: [patients, registration, goingToWards, goingToLab, labRegistration, analysis])
    model.simulate(forTime: 10000)
}

func main() {
    hospitalTask()
}

main()

