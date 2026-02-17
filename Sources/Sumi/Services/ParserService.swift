import Foundation

/// Protocol for converting between markdown text and the block model.
protocol ParserServiceProtocol: Sendable {

    /// Parse a markdown string into an array of blocks.
    func parse(markdown: String) -> [Block]

    /// Serialize an array of blocks back to a markdown string.
    func serialize(blocks: [Block]) -> String
}
