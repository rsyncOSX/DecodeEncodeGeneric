//
//  EncodeGeneric.swift
//  DecodeEncodeGeneric
//
//  Created by Thomas Evensen on 18/08/2024.
//

import Foundation

@MainActor
public final class EncodeGeneric {
    public private(set) var urlSession = URLSession.shared
    public private(set) var jsonEncoder = JSONEncoder()

    public func encodedata(data: some Codable) throws -> Data? {
        do {
            let jsondata = try jsonEncoder.encode(data)
            return jsondata
        } catch {
            return nil
        }
    }

    public init() {}
}
