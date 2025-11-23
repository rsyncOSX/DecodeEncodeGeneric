## Hi there 👋

Version 2.0.0

This package is generic code for decode and encode JSON data, as part of reading and writing data to local storage. Data are tasks, logrecords and user configuration.

The package is used in [RsyncUI](https://github.com/rsyncOSX/RsyncUI).

By Using Swift Package Manager (SPM), parts of the source code in RsyncUI is extraced and created as packages. The old code, the base for packages, is deleted and RsyncUI imports the new packages.  In Xcode 26 and later there is also module for test, Swift Testing, for testing packages. By SPM and Swift Testing, the code is modularized, isolated, and tested before committing changes.

# DecodeEncodeGeneric Documentation

A Swift package for encoding and decoding JSON data with support for strings, files, and remote URLs.

## Overview

DecodeEncodeGeneric provides a type-safe, generic approach to working with JSON in Swift. It handles common encoding/decoding scenarios while providing detailed error information and flexible configuration options.

## Features

- Generic decoding from strings, files, URLs, and raw Data
- Generic encoding to strings, files, and Data
- Configurable JSON encoder/decoder with custom strategies
- Comprehensive error handling with descriptive error messages
- Support for both single objects and arrays
- Async/await support for remote URL fetching
- Result-based API alternatives
- Pretty-printing convenience methods

## DecodeGeneric

### Initialization

```swift
// Basic initialization
let decoder = DecodeGeneric()

// Custom configuration
let decoder = DecodeGeneric(
    urlSession: .shared,
    jsonDecoder: JSONDecoder(),
    dateDecodingStrategy: .iso8601,
    keyDecodingStrategy: .convertFromSnakeCase
)
```

### Decoding from Strings

```swift
let jsonString = """
{
    "name": "John",
    "age": 30
}
"""

struct Person: Decodable {
    let name: String
    let age: Int
}

do {
    let person = try decoder.decode(Person.self, fromString: jsonString)
    print(person.name) // "John"
} catch {
    print("Error: \(error.localizedDescription)")
}
```

### Decoding Arrays from Strings

```swift
let jsonArray = """
[
    {"name": "John", "age": 30},
    {"name": "Jane", "age": 25}
]
"""

do {
    let people = try decoder.decodeArray(Person.self, fromString: jsonArray)
    print(people.count) // 2
} catch {
    print("Error: \(error)")
}
```

### Decoding from Files

```swift
do {
    let person = try decoder.decode(Person.self, fromFile: "/path/to/file.json")
    // or for arrays
    let people = try decoder.decodeArray(Person.self, fromFile: "/path/to/array.json")
} catch {
    print("Error: \(error)")
}
```

### Decoding from URLs (Async)

Requires macOS 12.0+ or iOS 15.0+

```swift
do {
    let person = try await decoder.decode(
        Person.self, 
        fromURL: "https://api.example.com/person"
    )
    
    // or for arrays
    let people = try await decoder.decodeArray(
        Person.self,
        fromURL: "https://api.example.com/people"
    )
} catch {
    print("Error: \(error)")
}
```

### Decoding from Data

```swift
let jsonData: Data = // ... your data
do {
    let person = try decoder.decode(Person.self, from: jsonData)
    // or for arrays
    let people = try decoder.decodeArray(Person.self, from: jsonData)
} catch {
    print("Error: \(error)")
}
```

## EncodeGeneric

### Initialization

```swift
// Basic initialization
let encoder = EncodeGeneric()

// Custom configuration
let encoder = EncodeGeneric(
    jsonEncoder: JSONEncoder(),
    outputFormatting: [.prettyPrinted, .sortedKeys],
    dateEncodingStrategy: .iso8601,
    keyEncodingStrategy: .convertToSnakeCase
)

// Pretty-printed convenience initializer
let prettyEncoder = EncodeGeneric.prettyPrinted()
```

### Encoding to Data

```swift
struct Person: Encodable {
    let name: String
    let age: Int
}

let person = Person(name: "John", age: 30)

do {
    let data = try encoder.encode(person)
    // or for arrays
    let people = [person]
    let arrayData = try encoder.encodeArray(people)
} catch {
    print("Error: \(error)")
}
```

### Encoding to String

```swift
do {
    let jsonString = try encoder.encodeToString(person)
    print(jsonString) // {"name":"John","age":30}
    
    // Pretty-printed string
    let prettyString = try encoder.encodeToPrettyString(person)
    
    // Array to string
    let arrayString = try encoder.encodeArrayToString([person])
} catch {
    print("Error: \(error)")
}
```

### Encoding to File

```swift
do {
    try encoder.encode(person, toFile: "/path/to/output.json")
    
    // With atomic write option (default is true)
    try encoder.encode(person, toFile: "/path/to/output.json", atomically: true)
    
    // Array to file
    try encoder.encodeArray([person], toFile: "/path/to/array.json")
} catch {
    print("Error: \(error)")
}
```

### Result-Based API

For situations where you prefer Result types over throwing functions:

```swift
let result = encoder.encodeResult(person)
switch result {
case .success(let data):
    print("Encoded successfully")
case .failure(let error):
    print("Error: \(error)")
}

let stringResult = encoder.encodeToStringResult(person)
switch stringResult {
case .success(let jsonString):
    print(jsonString)
case .failure(let error):
    print("Error: \(error)")
}
```

## Error Handling

### DecodeError

The package provides comprehensive error types with descriptive messages:

- `.invalidStringEncoding` - Failed to encode string as UTF-8 data
- `.invalidURL` - Invalid URL string
- `.invalidFilePath` - Invalid file path
- `.decodingFailed(Error)` - JSON decoding failed with underlying error
- `.fileReadFailed(Error)` - Failed to read file with underlying error

### EncodeError

- `.encodingFailed(Error)` - JSON encoding failed with underlying error
- `.fileWriteFailed(Error)` - Failed to write file with underlying error
- `.invalidFilePath` - Invalid file path
- `.stringConversionFailed` - Failed to convert data to UTF-8 string

## Advanced Usage

### Custom Date Strategies

```swift
let decoder = DecodeGeneric(
    dateDecodingStrategy: .iso8601
)

let encoder = EncodeGeneric(
    dateEncodingStrategy: .iso8601
)
```

### Custom Key Strategies

```swift
let decoder = DecodeGeneric(
    keyDecodingStrategy: .convertFromSnakeCase
)

let encoder = EncodeGeneric(
    keyEncodingStrategy: .convertToSnakeCase
)
```

### Custom URLSession

```swift
let config = URLSessionConfiguration.default
config.timeoutIntervalForRequest = 30
let customSession = URLSession(configuration: config)

let decoder = DecodeGeneric(urlSession: customSession)
```

## Requirements

- Swift 5.7+
- macOS 10.15+ / iOS 13.0+ (for basic functionality)
- macOS 12.0+ / iOS 15.0+ (for async URL decoding)

## Thread Safety

Both `DecodeGeneric` and `EncodeGeneric` are marked as `final` classes. The underlying `JSONDecoder` and `JSONEncoder` are thread-safe for read operations, but you should create separate instances for concurrent encoding/decoding operations.