//
//  TimeItem.swift
//  TimeFlows
//
//  Created by Oliver Brehm on 14.07.23.
//

import Foundation

class TimeItem: ObservableObject, Codable, Identifiable, Equatable {
    static func == (lhs: TimeItem, rhs: TimeItem) -> Bool {
        lhs.id == rhs.id
    }

    enum CodingKeys: CodingKey {
        case id, name, seconds
    }

    let id: UUID
    
    @Published var name: String
    @Published var seconds: UInt

    init(name: String, seconds: UInt) {
        id = UUID()

        self.name = name
        self.seconds = seconds
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        seconds = try container.decode(UInt.self, forKey: .seconds)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(seconds, forKey: .seconds)
    }
}
