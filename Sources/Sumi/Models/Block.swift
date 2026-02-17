import Foundation

/// The type of content a block represents.
enum BlockType: Codable, Hashable, Sendable {
    case paragraph
    case heading(level: Int)
    case bulletList
    case numberedList
    case todo(checked: Bool)
    case code(language: String?)
    case quote
    case divider
    case toggle
    case callout
    case image(url: URL?)
    case pageLink(documentID: UUID?)
}

/// A single block of content within a document.
///
/// Blocks are the fundamental editing unit in Sumi. Each block has a type,
/// text content, and optional nested children for indentation.
struct Block: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var type: BlockType
    var content: String
    var children: [Block]

    init(
        id: UUID = UUID(),
        type: BlockType = .paragraph,
        content: String = "",
        children: [Block] = []
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.children = children
    }
}


// MARK: - Convenience

extension Block {

    /// Whether this block has any text content.
    var hasContent: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Whether this block is a heading at any level.
    var isHeading: Bool {
        if case .heading = type { return true }
        return false
    }

    /// Whether this block is a list item (bullet, numbered, or todo).
    var isListItem: Bool {
        switch type {
        case .bulletList, .numberedList, .todo:
            return true
        default:
            return false
        }
    }
}
