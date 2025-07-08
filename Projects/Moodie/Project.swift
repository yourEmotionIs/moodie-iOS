import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeAppModule(
    name: Project.appName,
    dependencies: [
        .core(target: .coreFoundationKit)
    ]
)
