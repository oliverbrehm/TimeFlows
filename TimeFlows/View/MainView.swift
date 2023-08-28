//
//  MainView.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import SwiftUI

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

            timeFlowService?.timeFlows.append(TimeFlow(name: addFlowName, transitionSectonds: 0, items: []))

            showAddFlow = false
            addFlowName = ""
        }
    }
}

struct MainView: View {
    @EnvironmentObject private var timeFlowService: TimeFlowService
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach($timeFlowService.timeFlows, editActions: .delete) { $timeFlow in
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
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: { viewModel.showAddFlowView() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddFlow) {
                Form {
                    Section("Name") {
                        TextField("Name", text: $viewModel.addFlowName)
                    }

                    Button("Add", action: { viewModel.addFlow() })
                }
            }
            .onAppear {
                timeFlowService.synchronize()
                viewModel.timeFlowService = timeFlowService
            }
            .navigationTitle("TimeFlows")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject({ () -> TimeFlowService in
                let service = TimeFlowService()
                service.timeFlows = []

                service.timeFlows.append(TimeFlow(name: "Time Flow", transitionSectonds: 0, items: [
                    TimeItem(name: "Item 1", seconds: 5),
                    TimeItem(name: "Item 2", seconds: 3),
                    TimeItem(name: "Item 3", seconds: 8)
                ]))
                
                service.timeFlows.append(TimeFlow(name: "Flow 2", transitionSectonds: 2, items: []))
                service.timeFlows.append(TimeFlow(name: "Flow 3", transitionSectonds: 3, items: []))

                return service
            }())
    }
}
