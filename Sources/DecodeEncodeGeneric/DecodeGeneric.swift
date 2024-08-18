//
//  DecodeGeneric.swift
//  DecodeEncodeGeneric
//
//  Created by Thomas Evensen on 18/08/2024.
//

import Foundation

@available(macOS 14.0, *)
@MainActor
public final class DecodeGeneric {
    public private(set) var urlSession = URLSession.shared
    public private(set) var jsonDecoder = JSONDecoder()

    public func decodestringdata<T: Codable>(_ t: T.Type, fromwhere: String) async throws -> T? {
        if let url = URL(string: fromwhere) {
            let (data, _) = try await urlSession.getURLdata(for: url)
            return try jsonDecoder.decode(T.self, from: data)
        } else {
            return nil
        }
    }
    
    public func decodearraydata<T: Codable>(_ t: T.Type, fromwhere: String) async throws -> [T]? {
        if let url = URL(string: fromwhere) {
            let (data, _) = try await urlSession.getURLdata(for: url)
            return try jsonDecoder.decode([T].self, from: data)
        } else {
            return nil
        }
    }
}

@available(macOS 14.0, *)
public extension URLSession {
    func getURLdata(for url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url)
    }
}

