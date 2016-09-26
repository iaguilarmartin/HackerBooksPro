import Foundation

// Enum with the most common errors tracked inside the app
enum ApplicationErrors : Error {
    case invalidJSONURL
    case wrongJSONData
    case unrecognizedJSONData
    case wrongFileName
}
