import Foundation

/// Errors that can occur during file operations.
enum FileServiceError: LocalizedError {
    case fileNotFound(String)
    case readFailed(String, Error)
    case writeFailed(String, Error)
    case directoryCreationFailed(String, Error)
    case invalidPath(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            "File not found: \(path)"
        case .readFailed(let path, let error):
            "Failed to read \(path): \(error.localizedDescription)"
        case .writeFailed(let path, let error):
            "Failed to write \(path): \(error.localizedDescription)"
        case .directoryCreationFailed(let path, let error):
            "Failed to create directory \(path): \(error.localizedDescription)"
        case .invalidPath(let path):
            "Invalid path: \(path)"
        }
    }
}

/// Protocol for reading and writing markdown files on disk.
protocol FileServiceProtocol: Sendable {

    /// Read the contents of a markdown file.
    func readFile(at path: String) async throws -> String

    /// Write content to a markdown file, creating directories as needed.
    func writeFile(content: String, to path: String) async throws

    /// List all markdown files in a directory recursively.
    func listMarkdownFiles(in directory: String) async throws -> [String]

    /// Check if a file exists at the given path.
    func fileExists(at path: String) -> Bool

    /// Delete a file at the given path.
    func deleteFile(at path: String) async throws
}
