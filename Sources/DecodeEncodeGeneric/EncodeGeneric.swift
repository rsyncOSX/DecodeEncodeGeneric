//
//  EncodeGeneric.swift
//  DecodeEncodeGeneric
//
//  Created by Thomas Evensen on 18/08/2024.
//

import Foundation

@MainActor
public final class EncodeGeneric {
    let urlSession = URLSession.shared
    let jsonEncoder = JSONEncoder()

    public func encodedata<T: Codable>(_ t: T.Type, data: Data) async throws -> Data? {
        var jsondata = Data()
        do {
            jsondata = try jsonEncoder.encode(data)
        } catch {
            return nil
        }
        return jsondata
    }
}
