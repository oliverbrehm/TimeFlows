//
//  MainView.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var timeFlowService: TimeFlowService
    @State var showAddFlow = false
    @State var addFlowName = ""

    var body: some View {
        NavigationStack {
            List($timeFlowService.timeFlows, editActions: .delete) { $timeFlow in
                NavigationLink {
                    TimeFlowView(timeFlow: timeFlow)
                } label: {
                    Text(timeFlow.name)
                }

            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: showAddFlowView) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddFlow) {
                Form {
                    Section("Name") {
                        TextField("Name", text: $addFlowName)
                    }

                    Button("Add", action: addFlow)
                }
            }
            .onAppear {
                timeFlowService.synchronize()
            }
            .navigationTitle("TimeFlows")
        }
    }
}

// MARK: - Actions
extension MainView {
    private func showAddFlowView() {
        showAddFlow = true
    }

    private func addFlow() {
        guard !addFlowName.isEmpty else { return }

        timeFlowService.timeFlows.append(TimeFlow(name: addFlowName, transitionSectonds: 0, items: []))

        showAddFlow = false
        addFlowName = ""
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
