import SwiftUI
import PencilKit

struct NoteEditorView: View {
    @Environment(NoteStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var note: Note
    @State private var drawing: PKDrawing
    @State private var showToolPicker = true
    @State private var showTextField = false

    init(note: Note) {
        _note = State(initialValue: note)
        _drawing = State(initialValue: note.drawing)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            CanvasView(drawing: $drawing, toolPickerIsActive: $showToolPicker)
                .ignoresSafeArea(.container, edges: .bottom)

            if showTextField {
                textInputArea
            }
        }
        .navigationTitle(note.title.isEmpty ? "New Note" : note.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showTextField.toggle()
                    } label: {
                        Label(
                            showTextField ? "Hide Text" : "Add Text",
                            systemImage: "textformat"
                        )
                    }

                    Button {
                        showToolPicker.toggle()
                    } label: {
                        Label(
                            showToolPicker ? "Hide Tools" : "Show Tools",
                            systemImage: "pencil.tip.crop.circle"
                        )
                    }

                    Button {
                        clearCanvas()
                    } label: {
                        Label("Clear Canvas", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveNote()
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
        .onDisappear {
            saveNote()
        }
    }

    private var textInputArea: some View {
        VStack(spacing: 8) {
            TextField("Title", text: $note.title)
                .font(.headline)
                .textFieldStyle(.roundedBorder)

            TextField("Memo...", text: $note.textContent, axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding()
    }

    private func saveNote() {
        note.drawing = drawing
        store.save(note)
    }

    private func clearCanvas() {
        drawing = PKDrawing()
    }
}
