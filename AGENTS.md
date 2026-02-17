# AGENTS.md — Sumi (墨)

macOS-native markdown note-taking app with a Notion-style block-based editing experience.
Built with SwiftUI + Swift, local `.md` files on disk, and a SQLite index for search/metadata.

- **Target**: macOS 14+ (Sonoma), Xcode 16+, Swift 6
- **UI Framework**: SwiftUI (with AppKit bridging where needed for advanced text editing)
- **Data**: Plain markdown files (user-owned) + SQLite FTS5 index
- **Package Manager**: Swift Package Manager (SPM)

---

## Build / Lint / Test Commands

```bash
# Build (SPM)
swift build

# Build (Xcode)
xcodebuild -scheme Sumi -configuration Debug build

# Run all tests
swift test

# Run a single test class
swift test --filter SumiTests.BlockModelTests

# Run a single test method
swift test --filter SumiTests.BlockModelTests/testParagraphBlockCreation

# Xcode test (specific test)
xcodebuild test -scheme Sumi -only-testing:SumiTests/BlockModelTests/testParagraphBlockCreation

# Lint (SwiftLint — install via `brew install swiftlint`)
swiftlint lint --strict

# Format check (swift-format — install via `brew install swift-format`)
swift-format lint --recursive Sources/ Tests/
```

Always run `swift build` and the relevant `swift test --filter` before considering work done.

---

## Project Structure

```
Sumi/
├── App/                    # App entry point, WindowGroup, app-level config
├── Models/                 # Data models (Block, Document, Workspace)
│   ├── Block.swift         # Block type enum and block data model
│   ├── Document.swift      # Document model (title, blocks, metadata)
│   └── Workspace.swift     # Workspace/folder model
├── Views/                  # SwiftUI views
│   ├── Editor/             # Block editor views (core editing experience)
│   ├── Sidebar/            # Navigation sidebar, file tree, search
│   ├── Components/         # Reusable UI components
│   └── Settings/           # Preferences/settings views
├── ViewModels/             # Observable view models
├── Services/               # Business logic and I/O
│   ├── FileService.swift   # Markdown file read/write
│   ├── IndexService.swift  # SQLite FTS5 search index
│   ├── ParserService.swift # Markdown ↔ Block model conversion
│   └── SyncService.swift   # iCloud Drive sync coordination
├── Extensions/             # Swift/SwiftUI extensions
├── Resources/              # Assets, fonts, config files
└── Tests/
    └── SumiTests/          # Unit and integration tests
```

---

## Architecture

**Pattern**: MVVM with a service layer.

- **Models** are plain Swift structs. `Block` is the core unit.
- **ViewModels** are `@Observable` classes owning document state and coordinating services.
- **Views** are stateless SwiftUI views binding to view models.
- **Services** are protocol-defined, injected via environment or init for testability.

### Block-Based Editing Model (Notion-style)

- A `Document` contains an ordered list of `Block` values.
- Each `Block` has: `id: UUID`, `type: BlockType`, `content: AttributedContent`,
  `children: [Block]` (for nesting/indentation), and optional metadata.
- `BlockType` enum: `.paragraph`, `.heading(level:)`, `.bulletList`, `.numberedList`,
  `.todo(checked:)`, `.code(language:)`, `.quote`, `.divider`, `.toggle`, `.callout`,
  `.image`, `.pageLink`.
- Blocks render as individual SwiftUI views with per-block focus, selection, and drag-reorder.
- **Slash commands** (`/`): typing `/` in an empty or active block opens a command palette
  to convert or insert block types (paragraph, heading, list, code, quote, etc.).
- **@ mentions**: typing `@` triggers inline page/document linking. Resolved links are stored
  as inline tokens within block content and render as clickable chips.
- **Markdown serialization**: `ParserService` converts `[Block]` ↔ `.md` file content.
  Files on disk are always valid CommonMark. Custom block metadata uses HTML comments.

### Sidebar & Navigation

- Hierarchical file/folder tree reflecting the filesystem.
- Drag-and-drop reordering of pages and folders.
- Quick search (Cmd+K) backed by SQLite FTS5 — searches titles and content.
- Each page displays optional emoji icon and title in the sidebar.

---

## Code Style Guidelines

### Imports
- One import per line, sorted alphabetically.
- Import only what you need. Never use `@testable import` outside test targets.

### Formatting
- 4-space indentation (no tabs).
- Opening braces on same line. Max line length: 120 characters (soft).
- Trailing closure syntax for the last closure parameter.
- One blank line between methods. Two blank lines before `// MARK:` sections.

### Types & Data
- Prefer `struct` over `class` unless reference semantics are required.
- Models conform to `Identifiable`, `Codable`, `Hashable` where appropriate.
- Use `@Observable` (Observation framework) — not `ObservableObject`.
- Prefer `enum` with associated values over stringly-typed data.

### Naming
- Swift API Design Guidelines: clarity at the point of use.
- `camelCase` for variables/functions. `PascalCase` for types/protocols.
- Booleans read as assertions: `isEditing`, `hasContent`, `canDelete`.
- No abbreviations except universally understood ones (`URL`, `ID`, `FTS`).
- File names match the primary type: `Block.swift`, `EditorViewModel.swift`.

### SwiftUI Patterns
- Keep views small. Extract subviews when body exceeds ~40 lines.
- `@State` for view-local state, `@Environment` for shared dependencies.
- Pass data down; send actions up via closures or bindings.
- Prefer `.task {}` over `.onAppear` for async work.

### Error Handling
- Never force-unwrap (`!`) or `try!` in production code.
- Define typed errors per service: `enum FileServiceError: LocalizedError { ... }`.
- Surface errors to users via alerts or inline UI — never silently swallow.
- Log with `os.Logger` (subsystem: `com.sumi.app`, category per service).

### Concurrency
- Swift structured concurrency: `async`/`await`, `TaskGroup`, `AsyncSequence`.
- `@MainActor` or `actor` isolation for shared mutable state.
- File I/O and SQLite run off main actor. Never use `DispatchQueue` in new code.

### Testing
- Mirror source structure: `Models/Block.swift` → `Tests/SumiTests/BlockModelTests.swift`.
- Name descriptively: `test_blockType_paragraph_rendersAsText()`.
- Use `#expect()` (Swift Testing) — not XCTest assertions in new tests.
- Mock services via protocol conformance. Test block ↔ markdown round-trip thoroughly.

---

## Dependencies (SPM)

Keep dependencies minimal. Prefer Apple frameworks.

- **swift-markdown** (Apple) — CommonMark parsing
- **GRDB.swift** — SQLite access + FTS5 full-text search
- **SwiftLint** — linting (build tool plugin)

---

## Key Design Decisions

1. **Files are source of truth.** SQLite index is derived — rebuildable from disk at any time.
2. **Markdown compatibility.** Documents round-trip through CommonMark. Custom block types
   with no markdown equivalent use HTML comment markers.
3. **Offline-first.** Everything works without network. iCloud sync is file-level.
4. **Block-based editing.** Each block is a discrete view with focus state, slash-commands,
   drag-to-reorder, and type conversion.
5. **Performance.** Large documents (1000+ blocks) stay responsive via lazy loading.
