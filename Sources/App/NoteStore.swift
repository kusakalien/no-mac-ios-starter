import Foundation
import SwiftUI

@Observable
final class NoteStore {
    var notes: [Note] = []

    private let saveDirectory: URL

    init() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        saveDirectory = documents.appendingPathComponent("notes", isDirectory: true)
        try? FileManager.default.createDirectory(at: saveDirectory, withIntermediateDirectories: true)
        loadAll()
    }

    func save(_ note: Note) {
        var updated = note
        updated.updatedAt = Date()

        if let index = notes.firstIndex(where: { $0.id == updated.id }) {
            notes[index] = updated
        } else {
            notes.append(updated)
        }

        let fileURL = saveDirectory.appendingPathComponent("\(updated.id.uuidString).json")
        if let data = try? JSONEncoder().encode(updated) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        let fileURL = saveDirectory.appendingPathComponent("\(note.id.uuidString).json")
        try? FileManager.default.removeItem(at: fileURL)
    }

    func createNew() -> Note {
        let note = Note()
        save(note)
        return note
    }

    private func loadAll() {
        guard let files = try? FileManager.default.contentsOfDirectory(at: saveDirectory, includingPropertiesForKeys: nil) else {
            return
        }

        let decoder = JSONDecoder()
        notes = files
            .filter { $0.pathExtension == "json" }
            .compactMap { url -> Note? in
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? decoder.decode(Note.self, from: data)
            }
            .sorted { $0.updatedAt > $1.updatedAt }
    }
}
