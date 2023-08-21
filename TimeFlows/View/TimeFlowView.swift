//
//  TimeFlowView.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import SwiftUI

struct TimeFlowView: View {
    // MARK: - Environment
    @EnvironmentObject var timeFlowService: TimeFlowService

    // MARK: - State
    @ObservedObject var timeFlow: TimeFlow

    // MARK: - Private functions
    private func addItem() {
        let item = TimeItem(name: "Item", seconds: 60)
        timeFlow.items.append(item)
    }
}

// MARK: - UI
extension TimeFlowView {
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach($timeFlow.items, editActions: .delete) { $item in
                    NavigationLink {
                        EditItemView(item: item)
                    } label: {
                        HStack {
                            Text(item.name)
                                .font(.headline)

                            Spacer()

                            Text("\(item.seconds) seconds")
                                .font(.body)
                        }
                    }
                }

                Section {
                    Button(action: addItem) {
                        Text("Add item")
                    }

                    NavigationLink {
                        Form {
                            Section("Name") {
                                TextField("Name", text: $timeFlow.name)
                            }
                        }
                    } label: {
                        Text("Edit name")
                    }
                }
            }
        }
        .toolbar {
            if !timeFlow.items.isEmpty {
                ToolbarItem(placement: .automatic) {
                    NavigationLink {
                        TimeFlowActionView(timeFlow: timeFlow)
                    } label: {
                        Image(systemName: "play")
                    }
                }

                ToolbarItem(placement: .automatic) {
                    ShareLink(
                        item: timeFlow,
                        preview: SharePreview("\(timeFlow.name).csv")
                    )
                }
            }
        }
        .navigationTitle(timeFlow.name)
        .onAppear {
            timeFlow.objectWillChange.send()
            timeFlowService.synchronize()
        }
    }
}

// MARK: - Preview
#if DEBUG
struct TimeFlowView_Previews: PreviewProvider {
    static var previews: some View {
        TimeFlowView(timeFlow: TimeFlow(name: "Time Flow", transitionSectonds: 0, items: [
            TimeItem(name: "Item 1", seconds: 1),
            TimeItem(name: "Item 2", seconds: 2)
        ]))

        NavigationStack {
            TimeFlowView(timeFlow: TimeFlow(name: "Time Flow", transitionSectonds: 0, items: [
                TimeItem(name: "Item 1", seconds: 1),
                TimeItem(name: "Item 2", seconds: 2)
            ]))
        }
    }
}
#endif
