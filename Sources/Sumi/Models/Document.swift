import Foundation

/// A document is a single markdown file represented as an ordered list of blocks.
struct Document: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var title: String
    var blocks: [Block]
    var emojiIcon: String?
    var filePath: String?
    var createdAt: Date
    var modifiedAt: Date

    init(
        id: UUID = UUID(),
        title: String = "Untitled",
        blocks: [Block] = [],
        emojiIcon: String? = nil,
        filePath: String? = nil,
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.blocks = blocks
        self.emojiIcon = emojiIcon
        self.filePath = filePath
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}


// MARK: - Convenience

extension Document {

    /// The full plain-text content of the document (all blocks concatenated).
    var plainTextContent: String {
        blocks.map(\.content).joined(separator: "\n")
    }

    /// Approximate word count across all blocks.
    var wordCount: Int {
        blocks.reduce(0) { count, block in
            count + block.content.split(whereSeparator: \.isWhitespace).count
        }
    }

    /// Whether the document has been saved to disk.
    var isSaved: Bool {
        filePath != nil
    }
}
