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

    public func encodedata<T: Codable>(data: T) async throws -> Data? {
        do {
            let jsondata = try jsonEncoder.encode(data)
            return jsondata
        } catch {
            return nil
        }
        
    }
}
