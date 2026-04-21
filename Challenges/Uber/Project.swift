import ProjectDescription

// MARK: - Constants

let siteName = "Uber"
let bundlePrefix = "com.gui"
let deploymentTarget = "14.2"

// MARK: - Helpers

func commandLineTarget() -> Target {
    .target(
        name: siteName,
        destinations: .macOS,
        product: .commandLineTool,
        bundleId: "\(bundlePrefix).\(siteName.lowercased())",
        deploymentTargets: .macOS(deploymentTarget),
        sources: ["Application/Sources/**"]
    )
}

func testTarget() -> Target {
    .target(
        name: "\(siteName)Tests",
        destinations: .macOS,
        product: .unitTests,
        bundleId: "\(bundlePrefix).\(siteName.lowercased()).tests",
        deploymentTargets: .macOS(deploymentTarget),
        sources: [
            .glob("Application/Sources/**", excluding: ["Application/Sources/main.swift"]),
            "Application/Tests/**"
        ]
    )
}

// MARK: - Project

let project = Project(
    name: siteName,
    organizationName: "Gui",
    targets: [
        commandLineTarget(),
        testTarget()
    ]
)
