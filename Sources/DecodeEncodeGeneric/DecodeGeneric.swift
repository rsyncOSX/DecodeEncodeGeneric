//
//  DecodeGeneric.swift
//  DecodeEncodeGeneric
//
//  Created by Thomas Evensen on 18/08/2024.
//

import Foundation

public enum DecodeError: LocalizedError {
    case invalidStringEncoding
    case invalidURL
    case invalidFilePath
    case decodingFailed(Error)
    case fileReadFailed(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidStringEncoding:
            "Failed to encode string as UTF-8 data"
        case .invalidURL:
            "Invalid URL string"
        case .invalidFilePath:
            "Invalid file path"
        case .decodingFailed(let error):
            "JSON decoding failed: \(error.localizedDescription)"
        case .fileReadFailed(let error):
            "Failed to read file: \(error.localizedDescription)"
        }
    }
}

public final class DecodeGeneric {
    
    // MARK: - Properties
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    /// Creates a new DecodeGeneric instance
    /// - Parameters:
    ///   - urlSession: URLSession to use for network requests (default: .shared)
    ///   - jsonDecoder: JSONDecoder to use for decoding (default: JSONDecoder())
    ///   - dateDecodingStrategy: Optional date decoding strategy
    ///   - keyDecodingStrategy: Optional key decoding strategy
    public init(
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        
        if let dateStrategy = dateDecodingStrategy {
            self.jsonDecoder.dateDecodingStrategy = dateStrategy
        }
        if let keyStrategy = keyDecodingStrategy {
            self.jsonDecoder.keyDecodingStrategy = keyStrategy
        }
    }
    
    // MARK: - String Decoding
    
    /// Decodes a JSON string into a Decodable type
    /// - Parameters:
    ///   - type: The type to decode into
    ///   - string: JSON string to decode
    /// - Returns: Decoded object of type T
    /// - Throws: DecodeError if string encoding or decoding fails
    public func decode<T: Decodable>(_ type: T.Type = T.self, fromString string: String) throws -> T {
        guard let jsonData = string.data(using: .utf8) else {
            throw DecodeError.invalidStringEncoding
        }
        
        do {
            return try jsonDecoder.decode(T.self, from: jsonData)
        } catch {
            throw DecodeError.decodingFailed(error)
        }
    }
    
    /// Decodes a JSON string into an array of Decodable types
    /// - Parameters:
    ///   - type: The element type to decode into
    ///   - string: JSON string containing an array
    /// - Returns: Array of decoded objects
    /// - Throws: DecodeError if string encoding or decoding fails
    public func decodeArray<T: Decodable>(_ type: T.Type = T.self, fromString string: String) throws -> [T] {
        guard let jsonData = string.data(using: .utf8) else {
            throw DecodeError.invalidStringEncoding
        }
        
        do {
            return try jsonDecoder.decode([T].self, from: jsonData)
        } catch {
            throw DecodeError.decodingFailed(error)
        }
    }
    
    // MARK: - File Decoding
    
    /// Decodes JSON from a file into a Decodable type
    /// - Parameters:
    ///   - type: The type to decode into
    ///   - filePath: Path to the JSON file
    /// - Returns: Decoded object of type T
    /// - Throws: DecodeError if file reading or decoding fails
    public func decode<T: Decodable>(_ type: T.Type = T.self, fromFile filePath: String) throws -> T {
        guard !filePath.isEmpty else {
            throw DecodeError.invalidFilePath
        }
        
        let url = URL(fileURLWithPath: filePath, isDirectory: false)
        
        do {
            let data = try Data(contentsOf: url)
            return try decodeData(T.self, from: data)
        } catch let error as DecodeError {
            throw error
        } catch {
            throw DecodeError.fileReadFailed(error)
        }
    }
    
    /// Decodes JSON array from a file into an array of Decodable types
    /// - Parameters:
    ///   - type: The element type to decode into
    ///   - filePath: Path to the JSON file
    /// - Returns: Array of decoded objects
    /// - Throws: DecodeError if file reading or decoding fails
    public func decodeArray<T: Decodable>(_ type: T.Type = T.self, fromFile filePath: String) throws -> [T] {
        guard !filePath.isEmpty else {
            throw DecodeError.invalidFilePath
        }
        
        let url = URL(fileURLWithPath: filePath, isDirectory: false)
        
        do {
            let data = try Data(contentsOf: url)
            return try decodeDataArray([T].self, from: data)
        } catch let error as DecodeError {
            throw error
        } catch {
            throw DecodeError.fileReadFailed(error)
        }
    }
    
    // MARK: - URL Decoding (Async)
    
    /// Decodes JSON from a remote URL into a Decodable type
    /// - Parameters:
    ///   - type: The type to decode into
    ///   - urlString: URL string to fetch JSON from
    /// - Returns: Decoded object of type T
    /// - Throws: DecodeError if URL is invalid, network request fails, or decoding fails
    @available(macOS 12.0, iOS 15.0, *)
    public func decode<T: Decodable>(_ type: T.Type = T.self, fromURL urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw DecodeError.invalidURL
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            return try decodeData(T.self, from: data)
        } catch let error as DecodeError {
            throw error
        } catch {
            throw DecodeError.fileReadFailed(error)
        }
    }
    
    /// Decodes JSON array from a remote URL into an array of Decodable types
    /// - Parameters:
    ///   - type: The element type to decode into
    ///   - urlString: URL string to fetch JSON from
    /// - Returns: Array of decoded objects
    /// - Throws: DecodeError if URL is invalid, network request fails, or decoding fails
    @available(macOS 12.0, iOS 15.0, *)
    public func decodeArray<T: Decodable>(_ type: T.Type = T.self, fromURL urlString: String) async throws -> [T] {
        guard let url = URL(string: urlString) else {
            throw DecodeError.invalidURL
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            return try decodeDataArray([T].self, from: data)
        } catch let error as DecodeError {
            throw error
        } catch {
            throw DecodeError.fileReadFailed(error)
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// Decodes data into a Decodable type
    /// - Parameters:
    ///   - type: The type to decode into
    ///   - data: JSON data to decode
    /// - Returns: Decoded object of type T
    /// - Throws: DecodeError if decoding fails
    private func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw DecodeError.decodingFailed(error)
        }
    }
    
    /// Decodes data into an array of Decodable types
    /// - Parameters:
    ///   - type: The array type to decode into
    ///   - data: JSON data to decode
    /// - Returns: Array of decoded objects
    /// - Throws: DecodeError if decoding fails
    private func decodeDataArray<T: Decodable>(_ type: [T].Type, from data: Data) throws -> [T] {
        do {
            return try jsonDecoder.decode([T].self, from: data)
        } catch {
            throw DecodeError.decodingFailed(error)
        }
    }
}

// MARK: - Convenience Extensions

public extension DecodeGeneric {
    
    /// Decodes JSON from Data into a Decodable type
    /// - Parameters:
    ///   - type: The type to decode into
    ///   - data: JSON data to decode
    /// - Returns: Decoded object of type T
    /// - Throws: DecodeError if decoding fails
    func decode<T: Decodable>(_ type: T.Type = T.self, from data: Data) throws -> T {
        try decodeData(T.self, from: data)
    }
    
    /// Decodes JSON array from Data into an array of Decodable types
    /// - Parameters:
    ///   - type: The element type to decode into
    ///   - data: JSON data to decode
    /// - Returns: Array of decoded objects
    /// - Throws: DecodeError if decoding fails
    func decodeArray<T: Decodable>(_ type: T.Type = T.self, from data: Data) throws -> [T] {
        try decodeDataArray([T].self, from: data)
    }
}
