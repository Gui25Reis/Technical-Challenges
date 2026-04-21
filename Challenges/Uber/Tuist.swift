import ProjectDescription

let tuist = Tuist(
    project: .tuist(
        compatibleXcodeVersions: .upToNextMajor("26"),
        swiftVersion: "5.10"
    )
)
