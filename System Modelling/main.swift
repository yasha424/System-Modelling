//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

func main() {
//    let delays: [[Double]] = [
//        [2, 1, 1, 1], [2, 5, 1, 1], [2, 1, 5, 1], [2, 1, 1, 5],
//        [5, 1, 1, 1], [5, 5, 1, 1], [5, 1, 5, 1], [5, 1, 1, 5]
//    ]
//    let maxQueues = [
//        [10, 10, 10], [3, 10, 10], [10, 3, 10], [10, 10, 3]
//    ]
//    
//    for delay in delays {
//        for maxQueue in maxQueues {
//            let create = Create(delay: delay[0], name: "CREATOR")
//            let p1 = Process(delay: delay[1], name: "PROCESSOR-1", maxQueue: maxQueue[0], channels: 1)
//            let p2 = Process(delay: delay[2], name: "PROCESSOR-2", maxQueue: maxQueue[1], channels: 1)
//            let p3 = Process(delay: delay[3], name: "PROCESSOR-3", maxQueue: maxQueue[2], channels: 1)
//            
//            create.nextElements = [p1]
//            p1.nextElements = [p2]
//            p2.nextElements = [p3]
//            
//            let model = Model(elements: [create, p1, p2, p3])
//            model.simulate(forTime: 1000)
//        }
//    }
    
    let create = Create(delay: 2, name: "CREATOR")
    let process1 = Process(delay: 1, name: "PROCESSOR-1", maxQueue: 5, channels: 3)
    let process2 = Process(delay: 1, name: "PROCESSOR-2", maxQueue: 5, channels: 3)
    let process3 = Process(delay: 1, name: "PROCESSOR-3", maxQueue: 5, channels: 3)
    let process4 = Process(delay: 1, name: "PROCESSOR-4", maxQueue: 5, channels: 1)

    create.nextElements = [process1]
    process1.nextElements = [process2, process3, process4]
    process2.nextElements = [process1, process3, process4]
    process3.nextElements = [process1, process2, process4]

    let model = Model(elements: [create, process1, process2, process3])
    model.simulate(forTime: 1000)
}

main()
