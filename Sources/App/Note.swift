import Foundation
import PencilKit

struct Note: Identifiable, Codable {
    var id: UUID
    var title: String
    var textContent: String
    var drawingData: Data
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String = "",
        textContent: String = "",
        drawingData: Data = Data(),
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.textContent = textContent
        self.drawingData = drawingData
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var drawing: PKDrawing {
        get {
            (try? PKDrawing(data: drawingData)) ?? PKDrawing()
        }
        set {
            drawingData = newValue.dataRepresentation()
        }
    }
}
