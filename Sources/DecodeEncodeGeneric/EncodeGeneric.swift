//
//  EncodeGeneric.swift
//  DecodeEncodeGeneric
//
//  Created by Thomas Evensen on 18/08/2024.
//

import Foundation

@available(macOS 14.0, *)
@MainActor
public final class EncodeGeneric {
    let urlSession = URLSession.shared
    let jsonEncoder = JSONEncoder()

    public func encodedata<T: Codable>(_ t: T.Type, data: Data) async throws -> T? {
        return try jsonEncoder.encode(data) as? T
    }
    
}
