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
        DataRepresentation(contentType: .commaSeparatedText) { timeFlow in
            timeFlow.getCSVData()
        } importing: { data in
            TimeFlow(name: "", transitionSectonds: 0, items: [])
        }

        DataRepresentation(exportedContentType: .commaSeparatedText) { timeFlow in
            timeFlow.getCSVData()
        }
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
