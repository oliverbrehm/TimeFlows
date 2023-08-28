//
//  MainView+ViewModel.swift
//  SimpleTimeFlows
//
//  Created by Oliver Brehm on 28.08.23.
//

import Foundation

extension MainView {
    @MainActor class ViewModel: ObservableObject {
        var timeFlowService: TimeFlowService?

        @Published var showAddFlow = false
        @Published var addFlowName = ""

        func showAddFlowView() {
            showAddFlow = true
        }

        func addFlow() {
            guard !addFlowName.isEmpty else { return }

            timeFlowService?.addTimeFlow(with: addFlowName)

            showAddFlow = false
            addFlowName = ""
        }
    }
}
