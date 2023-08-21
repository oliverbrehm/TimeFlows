//
//  EditItemView.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 05.08.23.
//

import SwiftUI

struct EditItemView: View {
    // MARK: - Environment
    @ObservedObject var item: TimeItem

    // MARK: - State
    @State var seconds = 0
}

// MARK: - UI
extension EditItemView {
    var body: some View {
        Form {
            Section("Title") {
                TextField("Title", text: $item.name)
            }

            Section("Seconds") {
                Picker("Seconds", selection: $seconds) {
                    ForEach(1 ..< 600) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: seconds) { newValue in
                    item.seconds = UInt(seconds + 1)
                }
            }
        }
        .onAppear {
            seconds = Int(item.seconds) - 1
        }
    }
}

// MARK: - Preview
#if DEBUG
struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: TimeItem(name: "Test", seconds: 60))
    }
}
#endif
