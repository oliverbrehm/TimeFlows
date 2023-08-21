//
//  TimeFlowActionView.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import SwiftUI

struct TimeFlowActionView: View {
    // MARK: - State
    @State var currentItem = TimeItem(name: "", seconds: 0)
    @State var currentSeconds: UInt = 0
    @State var running = false

    // MARK: - Properties
    let timeFlow: TimeFlow

    // MARK: - Private properties
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var currentIndex: Int {
        timeFlow.items.firstIndex(of: currentItem) ?? 0
    }
}

// MARK: - Actions
extension TimeFlowActionView {
    private func countDown() {
        if currentSeconds == 0 {
            nextItem()
        } else {
            currentSeconds -= 1
        }
    }

    private func nextItem() {
        if timeFlow.items.indices.contains(currentIndex + 1) {
            setItem(timeFlow.items[currentIndex + 1])
        } else if let item = timeFlow.items.first {
            running = false
            setItem(item)
        }
    }

    private func previousItem() {
        if timeFlow.items.indices.contains(currentIndex - 1) {
            setItem(timeFlow.items[currentIndex - 1])
        } else if let item = timeFlow.items.first {
            running = false
            setItem(item)
        }
    }

    private func setItem(_ item: TimeItem) {
        currentItem = item
        currentSeconds = currentItem.seconds
    }
}

// MARK: - UI
extension TimeFlowActionView {
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                controlView(image: running ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")) {
                    running.toggle()
                }

                Spacer()

                VStack {
                    Text(currentItem.name)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.yellow)
                    Text("\(currentSeconds)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.orange)
                }
                .padding(20)
                .background(Color.blue)
                .cornerRadius(20)

                Spacer()

                VStack(spacing: 20) {
                    controlView(image: Image(systemName: "backward.fill"), action: previousItem)
                    controlView(image: Image(systemName: "forward.fill"), action: nextItem)
                }
            }
            .padding(20)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 5) {
                    ForEach(timeFlow.items) { item in
                        HStack {
                            Text(item.name)
                                .fontWeight(item == currentItem ? .bold : .regular)

                            Spacer()

                            Text("\(item.seconds) seconds")
                        }
                        .padding(5)
                        .background(Color.white)
                    }

                    Spacer()
                }
            }
            .padding([.top, .bottom], 20)
            .background(Color.gray.opacity(0.3))

            Spacer()
        }
        .onAppear {
            currentItem = timeFlow.items.first ?? TimeItem(name: "", seconds: 0)
            currentSeconds = currentItem.seconds
        }
        .onReceive(timer) { _ in
            if running {
                countDown()
            }
        }
    }

    private func controlView(image: Image, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            image
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding(20)
                .background(Color.blue)
                .clipShape(Circle())
        }
    }
}

// MARK: - Preview
#if DEBUG
struct TimeFlowActionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeFlowActionView(timeFlow: TimeFlow(name: "Time Flow", transitionSectonds: 0, items: [
            TimeItem(name: "Item 1", seconds: 5),
            TimeItem(name: "Item 2", seconds: 3),
            TimeItem(name: "Item 3", seconds: 8)
        ]))
    }
}
#endif
