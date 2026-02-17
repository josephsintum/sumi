import Foundation

/// A search result from the full-text search index.
struct SearchResult: Identifiable, Sendable {
    let id: String
    let title: String
    let path: String
    let snippet: String?
    let rank: Double
}

/// Protocol for the SQLite FTS5 search index.
protocol IndexServiceProtocol: Sendable {

    /// Set up the database and run migrations.
    func setup() async throws

    /// Index a single document file.
    func indexFile(at path: String, title: String, content: String) async throws

    /// Re-index all files in the workspace.
    func reindexAll(files: [(path: String, title: String, content: String)]) async throws

    /// Search documents using full-text search.
    func search(query: String) async throws -> [SearchResult]

    /// Get recently opened documents.
    func recentDocuments(limit: Int) async throws -> [SearchResult]

    /// Rebuild the FTS index from scratch.
    func rebuild() async throws
}
