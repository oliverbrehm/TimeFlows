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
    @ObservedObject var timeFlow: TimeFlow

    // MARK: - State
    @State private var showActionView = false
}

// MARK: - UI
extension TimeFlowView {
    var body: some View {
        VStack(spacing: 0) {
            List {
                itemList
                timeFlowConfiguration
            }
        }
        .toolbar {
            if !timeFlow.items.isEmpty {
                toolbar
            }
        }
        .navigationTitle(timeFlow.name)
        .fullScreenCover(isPresented: $showActionView, content: {
            TimeFlowActionView(timeFlow: timeFlow)
        })
        .onAppear {
            timeFlow.objectWillChange.send()
            timeFlowService.synchronize()
        }
    }

    private var itemList: some View {
        ForEach($timeFlow.items, editActions: [.delete, .move]) { $item in
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
    }

    private var timeFlowConfiguration: some View {
        Section {
            Button(action: timeFlow.addItem) {
                Text("Add item")
            }

            NavigationLink {
                Form {
                    Section("Name") {
                        TextField("Name", text: $timeFlow.name)
                    }
                }
                .navigationTitle("Edit name")
            } label: {
                Text("Edit name")
            }
        }
    }

    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            EditButton()
        }

        ToolbarItem(placement: .automatic) {
            Button {
                showActionView = true
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

// MARK: - Preview
#if DEBUG
struct TimeFlowView_Previews: PreviewProvider {
    static var previews: some View {
        TimeFlowView(timeFlow: TimeFlow(name: "Time Flow", items: [
            TimeItem(name: "Item 1", seconds: 1),
            TimeItem(name: "Item 2", seconds: 2)
        ]))

        NavigationStack {
            TimeFlowView(timeFlow: TimeFlow(name: "Time Flow", items: [
                TimeItem(name: "Item 1", seconds: 1),
                TimeItem(name: "Item 2", seconds: 2)
            ]))
        }
    }
}
#endif
