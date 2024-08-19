//
//  DecodeGeneric.swift
//  DecodeEncodeGeneric
//
//  Created by Thomas Evensen on 18/08/2024.
//

import Foundation

@MainActor
public final class DecodeGeneric {
    public private(set) var urlSession = URLSession.shared
    public private(set) var jsonDecoder = JSONDecoder()

    public func decodestringdatafileURL<T: Codable>(_: T.Type, fromwhere: String) throws -> T? {
        var data: Data?
        let url = URL(fileURLWithPath: fromwhere, isDirectory: false)
        do {
            data = try Data(contentsOf: url)
            if let data {
                return try jsonDecoder.decode(T.self, from: data)
            }
        } catch {
            return nil
        }
        return nil
    }

    public func decodearraydatafileURL<T: Codable>(_: T.Type, fromwhere: String) throws -> [T]? {
        var data: Data?
        let url = URL(fileURLWithPath: fromwhere, isDirectory: false)
        do {
            data = try Data(contentsOf: url)
            if let data {
                return try jsonDecoder.decode([T].self, from: data)
            }
        } catch {
            return nil
        }
        return nil
    }

    @available(macOS 12.0, *)
    public func decodestringdata<T: Codable>(_: T.Type, fromwhere: String) async throws -> T? {
        if let url = URL(string: fromwhere) {
            let (data, _) = try await urlSession.getURLdata(for: url)
            return try jsonDecoder.decode(T.self, from: data)
        } else {
            return nil
        }
    }

    @available(macOS 12.0, *)
    public func decodearraydata<T: Codable>(_: T.Type, fromwhere: String) async throws -> [T]? {
        if let url = URL(string: fromwhere) {
            let (data, _) = try await urlSession.getURLdata(for: url)
            return try jsonDecoder.decode([T].self, from: data)
        } else {
            return nil
        }
    }

    public init() {}
}

public extension URLSession {
    @available(macOS 12.0, *)
    func getURLdata(for url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url)
    }
}
