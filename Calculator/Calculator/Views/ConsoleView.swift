import SwiftUI

struct ConsoleView: View {
    let output: String
    let error: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Консоль:")
                .font(.headline)
                .foregroundColor(.primary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.textBackgroundColor))
                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        if !output.isEmpty {
                            Text(output)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                        
                        if let error = error {
                            Text("Ошибка: \(error)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.red)
                        }
                        
                        if output.isEmpty && error == nil {
                            Text("Результат выполнения появится здесь...")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .padding()
                }
            }
            .frame(minHeight: 120)
        }
    }
}
