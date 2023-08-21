//
//  TimeFlowsApp.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import SwiftUI

@main
struct TimeFlowsApp: App {
    private let timeFlowService = TimeFlowService()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(timeFlowService)
        }
    }
}
