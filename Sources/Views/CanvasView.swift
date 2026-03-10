import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var toolPickerIsActive: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .systemBackground
        canvasView.tool = PKInkingTool(.pen, color: .label, width: 3)
        canvasView.drawing = drawing

        context.coordinator.canvasView = canvasView

        let toolPicker = PKToolPicker()
        context.coordinator.toolPicker = toolPicker
        toolPicker.setVisible(toolPickerIsActive, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)

        if toolPickerIsActive {
            canvasView.becomeFirstResponder()
        }

        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        if canvasView.drawing != drawing {
            canvasView.drawing = drawing
        }

        let toolPicker = context.coordinator.toolPicker
        toolPicker?.setVisible(toolPickerIsActive, forFirstResponder: canvasView)
        if toolPickerIsActive {
            canvasView.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding var drawing: PKDrawing
        var canvasView: PKCanvasView?
        var toolPicker: PKToolPicker?

        init(drawing: Binding<PKDrawing>) {
            _drawing = drawing
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing = canvasView.drawing
        }
    }
}
