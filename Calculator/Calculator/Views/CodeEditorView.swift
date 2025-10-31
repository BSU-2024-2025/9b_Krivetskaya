import SwiftUI

struct CodeEditorView: View {
    @Binding var code: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Код:")
                .font(.headline)
                .foregroundColor(.primary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.textBackgroundColor))
                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
                
                TextEditor(text: $code)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
            }
            .frame(minHeight: 200)
            
            
        }
    }
}

struct SyntaxLegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}
