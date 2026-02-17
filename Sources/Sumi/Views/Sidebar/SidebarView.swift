import SwiftUI

public struct SidebarView: View {

    public init() {}

    public var body: some View {
        List {
            Section("Recent") {
                Text("No recent documents")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }

            Section("Documents") {
                Text("Open a workspace to get started")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Sumi")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Label("New Document", systemImage: "plus")
                }
            }
        }
    }
}
