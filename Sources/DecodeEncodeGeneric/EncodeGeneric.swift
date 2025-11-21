//
//  EncodeGeneric.swift
//  DecodeEncodeGeneric
//
//  Created by Thomas Evensen
//

import Foundation

public enum EncodeError: LocalizedError {
    case encodingFailed(Error)
    case fileWriteFailed(Error)
    case invalidFilePath
    case stringConversionFailed

    public var errorDescription: String? {
        switch self {
        case let .encodingFailed(error):
            "JSON encoding failed: \(error.localizedDescription)"
        case let .fileWriteFailed(error):
            "Failed to write file: \(error.localizedDescription)"
        case .invalidFilePath:
            "Invalid file path"
        case .stringConversionFailed:
            "Failed to convert data to UTF-8 string"
        }
    }
}

public final class EncodeGeneric {
    // MARK: - Properties

    private let jsonEncoder: JSONEncoder

    // MARK: - Initialization

    /// Creates a new EncodeGeneric instance
    /// - Parameters:
    ///   - jsonEncoder: JSONEncoder to use for encoding (default: JSONEncoder())
    ///   - outputFormatting: Optional output formatting options (e.g., .prettyPrinted)
    ///   - dateEncodingStrategy: Optional date encoding strategy
    ///   - keyEncodingStrategy: Optional key encoding strategy
    public init(
        jsonEncoder: JSONEncoder = JSONEncoder(),
        outputFormatting: JSONEncoder.OutputFormatting? = nil,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy? = nil,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy? = nil
    ) {
        self.jsonEncoder = jsonEncoder

        if let formatting = outputFormatting {
            self.jsonEncoder.outputFormatting = formatting
        }
        if let dateStrategy = dateEncodingStrategy {
            self.jsonEncoder.dateEncodingStrategy = dateStrategy
        }
        if let keyStrategy = keyEncodingStrategy {
            self.jsonEncoder.keyEncodingStrategy = keyStrategy
        }
    }

    /// Convenience initializer with pretty printing enabled
    /// - Returns: EncodeGeneric instance configured for pretty printing
    public static func prettyPrinted() -> EncodeGeneric {
        EncodeGeneric(outputFormatting: [.prettyPrinted, .sortedKeys])
    }

    // MARK: - Encoding to Data

    /// Encodes a Codable object to JSON Data
    /// - Parameter object: The object to encode
    /// - Returns: JSON data
    /// - Throws: EncodeError if encoding fails
    public func encode(_ object: some Encodable) throws -> Data {
        do {
            return try jsonEncoder.encode(object)
        } catch {
            throw EncodeError.encodingFailed(error)
        }
    }

    /// Encodes an array of Codable objects to JSON Data
    /// - Parameter array: The array to encode
    /// - Returns: JSON data
    /// - Throws: EncodeError if encoding fails
    public func encodeArray(_ array: [some Encodable]) throws -> Data {
        do {
            return try jsonEncoder.encode(array)
        } catch {
            throw EncodeError.encodingFailed(error)
        }
    }

    // MARK: - Encoding to String

    /// Encodes a Codable object to a JSON string
    /// - Parameter object: The object to encode
    /// - Returns: JSON string
    /// - Throws: EncodeError if encoding or string conversion fails
    public func encodeToString(_ object: some Encodable) throws -> String {
        let data = try encode(object)

        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodeError.stringConversionFailed
        }

        return jsonString
    }

    /// Encodes an array of Codable objects to a JSON string
    /// - Parameter array: The array to encode
    /// - Returns: JSON string
    /// - Throws: EncodeError if encoding or string conversion fails
    public func encodeArrayToString(_ array: [some Encodable]) throws -> String {
        let data = try encodeArray(array)

        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodeError.stringConversionFailed
        }

        return jsonString
    }

    // MARK: - Encoding to File

    /// Encodes a Codable object and writes it to a file
    /// - Parameters:
    ///   - object: The object to encode
    ///   - filePath: Path where the JSON file should be written
    ///   - atomically: If true, writes to a temporary file first (default: true)
    /// - Throws: EncodeError if encoding or file writing fails
    public func encode(_ object: some Encodable, toFile filePath: String, atomically: Bool = true) throws {
        guard !filePath.isEmpty else {
            throw EncodeError.invalidFilePath
        }

        let data = try encode(object)
        let url = URL(fileURLWithPath: filePath, isDirectory: false)

        do {
            try data.write(to: url, options: atomically ? .atomic : [])
        } catch {
            throw EncodeError.fileWriteFailed(error)
        }
    }

    /// Encodes an array of Codable objects and writes it to a file
    /// - Parameters:
    ///   - array: The array to encode
    ///   - filePath: Path where the JSON file should be written
    ///   - atomically: If true, writes to a temporary file first (default: true)
    /// - Throws: EncodeError if encoding or file writing fails
    public func encodeArray(_ array: [some Encodable], toFile filePath: String, atomically: Bool = true) throws {
        guard !filePath.isEmpty else {
            throw EncodeError.invalidFilePath
        }

        let data = try encodeArray(array)
        let url = URL(fileURLWithPath: filePath, isDirectory: false)

        do {
            try data.write(to: url, options: atomically ? .atomic : [])
        } catch {
            throw EncodeError.fileWriteFailed(error)
        }
    }
}

// MARK: - Convenience Extensions

public extension EncodeGeneric {
    /// Encodes a Codable object to pretty-printed JSON string
    /// - Parameter object: The object to encode
    /// - Returns: Pretty-printed JSON string
    /// - Throws: EncodeError if encoding or string conversion fails
    func encodeToPrettyString(_ object: some Encodable) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        do {
            let data = try encoder.encode(object)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw EncodeError.stringConversionFailed
            }
            return jsonString
        } catch {
            throw EncodeError.encodingFailed(error)
        }
    }
}

// MARK: - Result-based API (Alternative)

public extension EncodeGeneric {
    /// Encodes a Codable object to JSON Data, returning a Result type
    /// - Parameter object: The object to encode
    /// - Returns: Result containing Data on success or EncodeError on failure
    func encodeResult(_ object: some Encodable) -> Result<Data, EncodeError> {
        do {
            let data = try encode(object)
            return .success(data)
        } catch let error as EncodeError {
            return .failure(error)
        } catch {
            return .failure(.encodingFailed(error))
        }
    }

    /// Encodes a Codable object to JSON string, returning a Result type
    /// - Parameter object: The object to encode
    /// - Returns: Result containing String on success or EncodeError on failure
    func encodeToStringResult(_ object: some Encodable) -> Result<String, EncodeError> {
        do {
            let string = try encodeToString(object)
            return .success(string)
        } catch let error as EncodeError {
            return .failure(error)
        } catch {
            return .failure(.encodingFailed(error))
        }
    }
}
