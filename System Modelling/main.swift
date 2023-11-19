//
//  main.swift
//  System Modelling
//
//  Created by yasha on 03.11.2023.
//

import Foundation

func main() {
    let modelStructure: ModelStructure = .first
    
    var results = [Int: Double]()
    for n in stride(from: 10, through: 250, by: 10) {
        let count = 1

        results[n] = 0.0
        for _ in 0..<count {
            let model = Model<Any>(withNumProcesses: n, structure: modelStructure)
            let startTime = Date.timeIntervalSinceReferenceDate
            model.simulate(forTime: 1000)
            let endTime = Date.timeIntervalSinceReferenceDate
            results[n]! += (endTime - startTime) / Double(count)
        }
    }
    
    let sortedResults = results.sorted { $0.key < $1.key }
    for result in sortedResults.sorted(by: { $0.key < $1.key }) {
        print(result.key, result.value)
    }
    
    writeToCsv(results: sortedResults, fileName: "results1.csv")
}

func writeToCsv(results: Array<(key: Int, value: Double)>, fileName: String) {
    let fileManager = FileManager.default
    
    do {
        let path = try fileManager.url(for: .downloadsDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
        let fileUrl = path.appendingPathComponent(fileName)
        
        var csvString = "N,time (seconds)\n"
        for result in results {
            csvString += "\(result.key),\(Double(Int(result.value * 10000)) / 10000)\n"
        }
        try csvString.write(to: fileUrl, atomically: true, encoding: .utf8)
    } catch {}
}


main()
