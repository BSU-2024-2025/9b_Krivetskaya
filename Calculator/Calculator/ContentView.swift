import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "function")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("Калькулятор IDE")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 20) {
                    CodeEditorView(code: $viewModel.code)
                        .padding(.horizontal)
                    

                    HStack {
                        Button(action: {
                            Task {
                                await viewModel.runCode()
                            }
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Выполнить")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.isRunning ? Color.gray : Color.blue)
                            .cornerRadius(8)
                        }
                        .disabled(viewModel.isRunning)
                        
                        Button(action: viewModel.clearAll) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Очистить всё")
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    

                    VariablesView(variables: viewModel.variables, onClear: viewModel.clearAll)
                        .padding(.horizontal)
                    
    
                    ConsoleView(output: viewModel.output, error: viewModel.error)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
        .background(Color(.windowBackgroundColor))
        .frame(minWidth: 600, minHeight: 700)
    }
}
