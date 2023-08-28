//
//  TimeFlowActionView.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import SwiftUI

struct TimeFlowActionView: View {
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - State
    @StateObject var viewModel = ViewModel()

    // MARK: - Properties
    let timeFlow: TimeFlow
}

// MARK: - UI
extension TimeFlowActionView {
    var body: some View {
        VStack(spacing: 20) {
            controlBar.padding(20)

            timerView.padding(.horizontal, 40)

            ScrollView {
                itemList
            }
            .padding([.top, .bottom], 20)

            Spacer()
        }
        .onAppear {
            viewModel.timeFlow = timeFlow
            viewModel.onAppear()
        }
    }

    private var controlBar: some View {
        HStack {
            controlView(image: Image(systemName: "xmark"), color: .red) {
                dismiss()
            }

            Spacer()

            controlView(image: viewModel.running ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")) {
                viewModel.running.toggle()
            }

            Spacer()

            controlView(image: Image(systemName: "backward.fill"), action: { viewModel.previousItem() })
            controlView(image: Image(systemName: "forward.fill"), action: { viewModel.nextItem() })
        }
    }

    private var timerView: some View {
        VStack {
            Text(viewModel.currentItem.name)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.white)
            Text("\(viewModel.currentSeconds)")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.orange)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(20)
    }

    private var itemList: some View {
        LazyVStack(alignment: .leading, spacing: 5) {
            ForEach(timeFlow.items) { item in
                itemView(
                    name: item.name,
                    seconds: item.seconds,
                    isSelected: item == viewModel.currentItem
                )
            }

            Spacer()
        }
    }

    private func itemView(name: String, seconds: UInt, isSelected: Bool) -> some View {
        HStack {
            Text(name)
                .foregroundColor(.white)
                .fontWeight(isSelected ? .bold : .regular)

            Spacer()

            Text("\(seconds) seconds")
                .foregroundColor(.white)
        }
        .padding(5)
        .background(Color.blue.opacity(isSelected ? 1 : 0.3))
    }

    private func controlView(image: Image, color: Color = Color.blue, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            image
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding(20)
                .background(color)
                .clipShape(Circle())
        }
    }
}

// MARK: - Preview
#if DEBUG
struct TimeFlowActionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeFlowActionView(timeFlow: TimeFlow(name: "Time Flow", items: [
            TimeItem(name: "Item 1", seconds: 5),
            TimeItem(name: "Item 2", seconds: 3),
            TimeItem(name: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", seconds: 8)
        ]))
    }
}
#endif
