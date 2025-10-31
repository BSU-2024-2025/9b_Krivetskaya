import Foundation

public enum CalculatorError: Error, Equatable {
    case emptyInput
    case unexpectedCharacter(Character, Int)
    case invalidVariableName(String)
    case invalidAssignmentSyntax
    case divisionByZero
    case unknownFunction(String)
    case unknownVariable(String, Int)
    case invalidFunctionSyntax(String)
    
    public var localizedDescription: String {
        switch self {
        case .emptyInput:
            return "Ввод не может быть пустым."
        case .unexpectedCharacter(let char, let pos):
            return "Неожиданный символ '\(char)' на позиции \(pos)"
        case .invalidVariableName(let name):
            return "Неверное имя переменной: \(name)"
        case .invalidAssignmentSyntax:
            return "Неверный синтаксис присваивания"
        case .divisionByZero:
            return "Деление на ноль невозможно."
        case .unknownFunction(let name):
            return "Неизвестная функция '\(name)'"
        case .unknownVariable(let name, let pos):
            return "Неизвестная переменная '\(name)' на позиции \(pos)"
        case .invalidFunctionSyntax(let name):
            return "Неверный синтаксис функции '\(name)'. Используйте: функция(аргумент)"
        }
    }
}
