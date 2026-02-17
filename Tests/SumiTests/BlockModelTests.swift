import Foundation
import XCTest

@testable import Sumi

final class BlockModelTests: XCTestCase {

    func testParagraphBlockCreation() {
        let block = Block()
        XCTAssertEqual(block.type, .paragraph)
        XCTAssertEqual(block.content, "")
        XCTAssertTrue(block.children.isEmpty)
        XCTAssertFalse(block.hasContent)
    }

    func testHeadingBlockCreation() {
        let block = Block(type: .heading(level: 1), content: "Hello World")
        XCTAssertTrue(block.isHeading)
        XCTAssertTrue(block.hasContent)
        XCTAssertEqual(block.content, "Hello World")
    }

    func testListItemDetection() {
        let bullet = Block(type: .bulletList, content: "Item")
        let numbered = Block(type: .numberedList, content: "Item")
        let todo = Block(type: .todo(checked: false), content: "Task")
        let paragraph = Block(type: .paragraph, content: "Text")

        XCTAssertTrue(bullet.isListItem)
        XCTAssertTrue(numbered.isListItem)
        XCTAssertTrue(todo.isListItem)
        XCTAssertFalse(paragraph.isListItem)
    }

    func testBlockWithChildren() {
        let child = Block(type: .paragraph, content: "Nested")
        let parent = Block(type: .bulletList, content: "Parent", children: [child])

        XCTAssertEqual(parent.children.count, 1)
        XCTAssertEqual(parent.children.first?.content, "Nested")
    }

    func testBlockIdentityViaUUID() {
        let block1 = Block(content: "Same content")
        let block2 = Block(content: "Same content")

        XCTAssertNotEqual(block1.id, block2.id)
    }

    func testHasContentTrimsWhitespace() {
        let empty = Block(content: "")
        let whitespace = Block(content: "   \n  ")
        let real = Block(content: " Hello ")

        XCTAssertFalse(empty.hasContent)
        XCTAssertFalse(whitespace.hasContent)
        XCTAssertTrue(real.hasContent)
    }
}
