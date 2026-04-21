import Foundation

// MARK: - Protocol

protocol InputProvider {
    func readLine() -> String?
    func print(_ value: String)
    var dataPrinted: String { get }
}

// MARK: - Default (CommandLine)

final class DefaultInputProvider: InputProvider {
    private(set) var dataPrinted: String = ""

    func readLine() -> String? {
        Swift.readLine()
    }

    func print(_ value: String) {
        Swift.print(value)
    }
}

// MARK: - Mock (Tests)

final class MockInputProvider: InputProvider {
    private var inputs: [String]
    private(set) var dataPrinted: String = ""

    init(inputs: [String]) {
        self.inputs = inputs
    }

    func readLine() -> String? {
        inputs.isEmpty ? nil : inputs.removeFirst()
    }

    func print(_ value: String) {
        dataPrinted += dataPrinted.isEmpty ? value : "\n\(value)"
    }
}
