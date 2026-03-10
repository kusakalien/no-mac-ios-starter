import SwiftUI
import PencilKit

struct NotesListView: View {
    @Environment(NoteStore.self) private var store

    var body: some View {
        List {
            ForEach(store.notes) { note in
                NavigationLink(value: note.id) {
                    NoteRowView(note: note)
                }
            }
            .onDelete(perform: deleteNotes)
        }
        .overlay {
            if store.notes.isEmpty {
                ContentUnavailableView(
                    "No Notes",
                    systemImage: "pencil.tip.crop.circle",
                    description: Text("Tap + to create your first drawing note.")
                )
            }
        }
        .navigationTitle("Drawing Notes")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: UUID?.none as UUID?) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(for: UUID.self) { noteID in
            if let note = store.notes.first(where: { $0.id == noteID }) {
                NoteEditorView(note: note)
            }
        }
        .navigationDestination(for: UUID?.self) { _ in
            NoteEditorView(note: store.createNew())
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            store.delete(store.notes[index])
        }
    }
}

struct NoteRowView: View {
    let note: Note

    var body: some View {
        HStack(spacing: 12) {
            drawingThumbnail
                .frame(width: 60, height: 60)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(.headline)
                    .lineLimit(1)

                if !note.textContent.isEmpty {
                    Text(note.textContent)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Text(note.updatedAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var drawingThumbnail: some View {
        let drawing = note.drawing
        if drawing.strokes.isEmpty {
            Image(systemName: "pencil.tip")
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            let image = drawing.image(from: drawing.bounds, scale: 1.0)
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(4)
        }
    }
}
