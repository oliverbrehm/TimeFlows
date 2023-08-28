//
//  TimeFlow.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import Foundation

class TimeFlow: ObservableObject, Codable, Identifiable {
    // MARK: - Inner types
    enum CodingKeys: CodingKey {
        case id, name, transitionSeconds, items
    }

    // MARK: - Properties
    let id: UUID

    @Published var name: String
    @Published var items: [TimeItem]

    // MARK: - Initializers
    init(name: String, items: [TimeItem]) {
        self.id = UUID()
        self.name = name
        self.items = items
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        items = try container.decode([TimeItem].self, forKey: .items)
    }

    // MARK: - Functions
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(items, forKey: .items)
    }

    func addItem() {
        let item = TimeItem(name: "Item", seconds: 5)
        items.append(item)
    }
}
