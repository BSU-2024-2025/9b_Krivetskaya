import Foundation

@MainActor
class CalculatorViewModel: ObservableObject {
    @Published var code: String = """
// Добро пожаловать в калькулятор!
// Примеры:

2 + 3
x = 5
y = 3
x + y
10 / 2
"""
    @Published var output: String = ""
    @Published var error: String?
    @Published var isRunning = false
    @Published var variables: [String: Double] = [:]
    
    private let calculator = Calculator()
    
    func runCode() async {
        isRunning = true
        error = nil
        output = ""
        
        let lines = code.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && !$0.hasPrefix("//") }
        
        var results: [String] = []
        
        for line in lines {
            do {
                let result = try calculator.evaluate(line)
                let cleanLine = removeCommentsFromLine(line)
                if !cleanLine.isEmpty {
                    results.append("\(cleanLine) = \(result)")
                }
            } catch {
                let cleanLine = removeCommentsFromLine(line)
                self.error = "Ошибка в '\(cleanLine)': \(error.localizedDescription)"
                break
            }
        }
        
        output = results.joined(separator: "\n")
        variables = calculator.variables
        isRunning = false
    }
    
    private func removeCommentsFromLine(_ line: String) -> String {
        if let commentRange = line.range(of: "//") {
            return String(line[..<commentRange.lowerBound])
                .trimmingCharacters(in: .whitespaces)
        }
        return line.trimmingCharacters(in: .whitespaces)
    }
    
    func clearAll() {
        calculator.clearVariables()
        output = ""
        error = nil
        variables = [:]
        code = """
// Код очищен
// Введите выражения:

2 + 2
x = 10
x * 2
"""
    }
}
