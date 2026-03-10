import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NotesListView()
        }
    }
}

#Preview {
    ContentView()
        .environment(NoteStore())
}
