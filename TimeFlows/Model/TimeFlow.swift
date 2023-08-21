//
//  TimeFlow.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import Foundation

class TimeFlow: ObservableObject, Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case id, name, transitionSeconds, items
    }

    let id: UUID
    let transitionSeconds: UInt

    @Published var name: String
    @Published var items: [TimeItem]

    init(name: String, transitionSectonds: UInt, items: [TimeItem]) {
        self.id = UUID()
        self.name = name
        self.transitionSeconds = transitionSectonds
        self.items = items
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        transitionSeconds = try container.decode(UInt.self, forKey: .transitionSeconds)
        items = try container.decode([TimeItem].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(transitionSeconds, forKey: .transitionSeconds)
        try container.encode(items, forKey: .items)
    }
}
