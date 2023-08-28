//
//  TimeFlowService.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import Foundation

class TimeFlowService: ObservableObject {
    // MARK: - Properties
    @Published var timeFlows: [TimeFlow] = [] {
        didSet {
            synchronize()
        }
    }

    // MARK: - Initializers
    init() {
        if let clearData = ProcessInfo.processInfo.environment["clear_data"], clearData == "1" {
            clear()
        } else if let json = UserDefaults.standard.value(forKey: "TimeFlows") as? Data {
            timeFlows = (try? JSONDecoder().decode([TimeFlow].self, from: Data(json))) ?? []
        }

        synchronize()
        
    }

    // MARK: - Functions
    func clear() {
        timeFlows = []
    }

    func addTimeFlow(with name: String) {
        timeFlows.append(TimeFlow(name: name, items: []))
    }
    
    func synchronize() {
        if let json = try? JSONEncoder().encode(timeFlows) {
            UserDefaults.standard.set(json, forKey: "TimeFlows")
            UserDefaults.standard.synchronize()
        }

        objectWillChange.send()
    }
}
