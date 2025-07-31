import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeAppModule(
    name: Project.appName,
    dependencies: [
        .feature(target: .moodieAuth),
        .core(target: .coreFoundationKit)
    ]
)
