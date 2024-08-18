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

    func encodestringdata<T: Encodable>(_ t: T.Type, fromwhere: String) async throws -> T? {
        if let url = URL(string: fromwhere) {
            let (data, _) = try await urlSession.getURLdata(for: url)
            return try jsonEncoder.encode(data) as? T
        } else {
            return nil
        }
    }
    
    func encodearraydata<T: Encodable>(_ t: T.Type, fromwhere: String) async throws -> [T]? {
        if let url = URL(string: fromwhere) {
            let (data, _) = try await urlSession.getURLdata(for: url)
            return try jsonEncoder.encode(data) as? [T]
        } else {
            return nil
        }
    }
}
