//
//  TimeFlowActionView+ViewModel.swift
//  SimpleTimeFlowsTests
//
//  Created by Oliver Brehm on 28.08.23.
//

import Foundation

extension TimeFlowActionView {
    @MainActor class ViewModel: ObservableObject {
        // MARK: - Properties
        @Published var currentItem = TimeItem(name: "", seconds: 0)
        @Published var currentSeconds: UInt = 0
        @Published var running = false

        var timeFlow = TimeFlow(name: "", items: [])

        var currentIndex: Int {
            timeFlow.items.firstIndex(of: currentItem) ?? 0
        }

        // MARK: - Private properties
        private var timer: Timer?

        // MARK: - Functions
        func onAppear() {
            currentItem = timeFlow.items.first ?? TimeItem(name: "", seconds: 0)
            currentSeconds = currentItem.seconds

            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.onTick()
                }
            }
        }

        func nextItem() {
            if timeFlow.items.indices.contains(currentIndex + 1) {
                setItem(timeFlow.items[currentIndex + 1])
            } else if let item = timeFlow.items.first {
                running = false
                setItem(item)
            }
        }

        func previousItem() {
            if timeFlow.items.indices.contains(currentIndex - 1) {
                setItem(timeFlow.items[currentIndex - 1])
            } else if let item = timeFlow.items.first {
                running = false
                setItem(item)
            }
        }

        // MARK: - Private functions
        private func setItem(_ item: TimeItem) {
            currentItem = item
            currentSeconds = currentItem.seconds
        }

        private func onTick() {
            if running {
                if currentSeconds == 0 {
                    nextItem()
                } else {
                    currentSeconds -= 1
                }
            }
        }
    }
}
