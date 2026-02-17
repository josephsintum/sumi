import Foundation
import XCTest

@testable import Sumi

final class DocumentModelTests: XCTestCase {

    func testDocumentCreation() {
        let doc = Document()
        XCTAssertEqual(doc.title, "Untitled")
        XCTAssertTrue(doc.blocks.isEmpty)
        XCTAssertNil(doc.emojiIcon)
        XCTAssertNil(doc.filePath)
        XCTAssertFalse(doc.isSaved)
    }

    func testPlainTextContentJoinsBlocks() {
        let doc = Document(
            title: "Test",
            blocks: [
                Block(content: "First paragraph"),
                Block(type: .heading(level: 1), content: "Heading"),
                Block(content: "Second paragraph"),
            ]
        )

        XCTAssertEqual(doc.plainTextContent, "First paragraph\nHeading\nSecond paragraph")
    }

    func testWordCount() {
        let doc = Document(
            title: "Test",
            blocks: [
                Block(content: "Hello world"),
                Block(content: "Three more words"),
            ]
        )

        XCTAssertEqual(doc.wordCount, 5)
    }

    func testIsSavedReflectsFilePath() {
        var doc = Document()
        XCTAssertFalse(doc.isSaved)

        doc.filePath = "/path/to/file.md"
        XCTAssertTrue(doc.isSaved)
    }
}
