//
//  TimeFlowService.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import Foundation

class TimeFlowService: ObservableObject {
    @Published var timeFlows: [TimeFlow] = [] {
        didSet {
            synchronize()
        }
    }

    init() {
        if let json = UserDefaults.standard.value(forKey: "TimeFlows") as? Data {
            timeFlows = (try? JSONDecoder().decode([TimeFlow].self, from: Data(json))) ?? []
        }
    }

    func synchronize() {
        if let json = try? JSONEncoder().encode(timeFlows) {
            UserDefaults.standard.set(json, forKey: "TimeFlows")
        }

        objectWillChange.send()
    }
}
