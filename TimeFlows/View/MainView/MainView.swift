//
//  MainView.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import SwiftUI

struct MainView: View {
    // MARK: - Environment
    @EnvironmentObject private var timeFlowService: TimeFlowService

    // MARK: - State
    @StateObject private var viewModel = ViewModel()
}

// MARK: - UI
extension MainView {
    var body: some View {
        NavigationStack {
            timeFlowList
            .toolbar {
                toolbar
            }
            .sheet(isPresented: $viewModel.showAddFlow) {
                addTimeFlowView
            }
            .onAppear {
                timeFlowService.synchronize()
                viewModel.timeFlowService = timeFlowService
            }
            .navigationTitle("TimeFlows")
        }
    }

    private var timeFlowList: some View {
        List {
            ForEach($timeFlowService.timeFlows, editActions: [.delete, .move]) { $timeFlow in
                NavigationLink {
                    TimeFlowView(timeFlow: timeFlow)
                } label: {
                    Text(timeFlow.name)
                }
            }

            if $timeFlowService.timeFlows.isEmpty {
                Text("Add a time flow to get started!")
            }
        }
    }

    private var addTimeFlowView: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $viewModel.addFlowName)
            }

            Button("Add", action: { viewModel.addFlow() })
        }
    }

    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        if !timeFlowService.timeFlows.isEmpty {
            ToolbarItem(placement: .automatic) {
                EditButton()
            }
        }

        ToolbarItem(placement: .automatic) {
            Button(action: { viewModel.showAddFlowView() }) {
                Image(systemName: "plus")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject({ () -> TimeFlowService in
                let service = TimeFlowService()
                service.timeFlows = []

                service.timeFlows.append(TimeFlow(name: "Time Flow", items: [
                    TimeItem(name: "Item 1", seconds: 5),
                    TimeItem(name: "Item 2", seconds: 3),
                    TimeItem(name: "Item 3", seconds: 8)
                ]))
                
                service.timeFlows.append(TimeFlow(name: "Flow 2", items: []))
                service.timeFlows.append(TimeFlow(name: "Flow 3", items: []))

                return service
            }())
    }
}
