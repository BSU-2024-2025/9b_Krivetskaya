import Foundation
import Combine

public class Calculator: ObservableObject {
    @Published public private(set) var variables: [String: Double] = [:]
    
    private let functions: Set<String> = ["sin", "cos", "exp"]
    
    public init() {}
    
    public func evaluate(_ expression: String?) throws -> Double {
        guard let expression = expression, !expression.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw CalculatorError.emptyInput
        }
        
        let cleanExpression = removeComments(expression)
        return try evaluateExpression(cleanExpression)
    }
    
    public func clearVariables() {
        variables.removeAll()
    }
    
    public func setVariable(_ name: String, value: Double) {
        variables[name] = value
    }
    
    private func removeComments(_ expression: String) -> String {
        let lines = expression.components(separatedBy: .newlines)
        let cleanLines = lines.map { line in
            if let commentRange = line.range(of: "//") {
                return String(line[..<commentRange.lowerBound])
                    .trimmingCharacters(in: .whitespaces)
            }
            return line.trimmingCharacters(in: .whitespaces)
        }
        .filter { !$0.isEmpty }
        
        return cleanLines.joined(separator: "\n")
    }
    
    private func evaluateExpression(_ expression: String) throws -> Double {
        let cleanExpr = expression.trimmingCharacters(in: .whitespaces)
        

        if let value = Double(cleanExpr) {
            return value
        }
        
        if let variableValue = variables[cleanExpr] {
            return variableValue
        }
        
        if let functionCall = try? parseFunctionCall(cleanExpr) {
            return functionCall
        }
        
        let operators = ["+", "-", "*", "/"]
        for op in operators {
            if cleanExpr.contains(op) {
                let parts = cleanExpr.split(separator: Character(op))
                if parts.count == 2 {
                    let left = try evaluateExpression(String(parts[0]))
                    let right = try evaluateExpression(String(parts[1]))
                    
                    switch op {
                    case "+": return left + right
                    case "-": return left - right
                    case "*": return left * right
                    case "/":
                        if right == 0 { throw CalculatorError.divisionByZero }
                        return left / right
                    default: break
                    }
                }
            }
        }
        
        if cleanExpr.contains("=") {
            let parts = cleanExpr.split(separator: "=")
            if parts.count == 2 {
                let varName = String(parts[0]).trimmingCharacters(in: .whitespaces)
                let valueExpr = String(parts[1]).trimmingCharacters(in: .whitespaces)
                
                if !isValidVariableName(varName) {
                    throw CalculatorError.invalidVariableName(varName)
                }
                
                let value = try evaluateExpression(valueExpr)
                variables[varName] = value
                return value
            }
        }
        
        throw CalculatorError.unknownVariable(cleanExpr, 1)
    }
    
    private func parseFunctionCall(_ expression: String) throws -> Double {
        guard let openParenIndex = expression.firstIndex(of: "("),
              expression.last == ")" else {
            throw CalculatorError.unknownFunction(expression)
        }
        
        let functionName = String(expression[..<openParenIndex]).trimmingCharacters(in: .whitespaces)
        

        guard functions.contains(functionName) else {
            throw CalculatorError.unknownFunction(functionName)
        }
        

        let argumentStart = expression.index(after: openParenIndex)
        let argumentEnd = expression.index(before: expression.endIndex)
        let argumentString = String(expression[argumentStart..<argumentEnd]).trimmingCharacters(in: .whitespaces)
        
        let argument = try evaluateExpression(argumentString)
        

        return applyFunction(functionName, argument: argument)
    }
    
    private func applyFunction(_ functionName: String, argument: Double) -> Double {
        switch functionName {
        case "sin":
            return sin(argument)
        case "cos":
            return cos(argument)
        case "exp":
            return exp(argument)
        default:
            return 0.0
        }
    }
    
    private func isValidVariableName(_ name: String) -> Bool {
        guard let firstChar = name.first else { return false }
        return firstChar.isLetter || firstChar == "_"
    }
}
