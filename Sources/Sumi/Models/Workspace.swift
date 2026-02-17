import Foundation

/// Represents an item in the workspace file tree.
enum WorkspaceItem: Identifiable, Hashable, Sendable {
    case folder(WorkspaceFolder)
    case document(WorkspaceDocument)

    var id: String {
        switch self {
        case .folder(let folder): folder.id
        case .document(let document): document.id
        }
    }

    var name: String {
        switch self {
        case .folder(let folder): folder.name
        case .document(let document): document.name
        }
    }

    var path: String {
        switch self {
        case .folder(let folder): folder.path
        case .document(let document): document.path
        }
    }
}

/// A folder in the workspace hierarchy.
struct WorkspaceFolder: Identifiable, Hashable, Sendable {
    let id: String
    var name: String
    var path: String
    var children: [WorkspaceItem]

    init(name: String, path: String, children: [WorkspaceItem] = []) {
        self.id = path
        self.name = name
        self.path = path
        self.children = children
    }
}

/// A document reference in the workspace (lightweight, for sidebar display).
struct WorkspaceDocument: Identifiable, Hashable, Sendable {
    let id: String
    var name: String
    var path: String
    var emojiIcon: String?

    init(name: String, path: String, emojiIcon: String? = nil) {
        self.id = path
        self.name = name
        self.path = path
        self.emojiIcon = emojiIcon
    }
}

/// The root workspace representing a user's notes directory.
struct Workspace: Sendable {
    var rootPath: String
    var items: [WorkspaceItem]

    init(rootPath: String, items: [WorkspaceItem] = []) {
        self.rootPath = rootPath
        self.items = items
    }
}
