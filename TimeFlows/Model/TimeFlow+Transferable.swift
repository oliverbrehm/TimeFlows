//
//  TimeFlow+Transferable.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 01.08.23.
//

import CSVData
import SwiftUI

enum TimeFlowCSVFormat: String, CSVFormat {
    case name
    case seconds
}

extension TimeFlow: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .commaSeparatedText) { timeFlow in
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(timeFlow.name).appendingPathExtension("csv")
            try timeFlow.getCSVData().write(to: fileURL)

            return SentTransferredFile(fileURL)
        }
        .suggestedFileName("TimeFlow.csv")
    }

    func getCSVData() -> Data {
        let csvData = CSVData<TimeFlowCSVFormat>(items: items) { item, column in
            switch column {
            case .name:
                return item.name
            case .seconds:
                return "\(item.seconds)"
            }
        }

        return Data(csvData.csvString().utf8)
    }
}
