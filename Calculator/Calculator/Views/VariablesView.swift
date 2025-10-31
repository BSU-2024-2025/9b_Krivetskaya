import SwiftUI

struct VariablesView: View {
    let variables: [String: Double]
    let onClear: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Переменные:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Очистить", action: onClear)
                    .foregroundColor(.red)
            }
            
            if variables.isEmpty {
                Text("Нет переменных")
                    .foregroundColor(.secondary)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(variables.keys.sorted()), id: \.self) { key in
                            HStack {
                                Text(key)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.blue)
                                
                                Text("=")
                                    .foregroundColor(.primary)
                                
                                Text(String(format: "%.2f", variables[key] ?? 0))
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 150)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.textBackgroundColor))
                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
                )
            }
        }
    }
}
