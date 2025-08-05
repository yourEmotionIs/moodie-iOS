//
//  Project.swift
//  MoodieManifests
//
//  Created by 이하연 on 7/27/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    target: .moodieOnboarding,
    dependencies: [
        .core(target: .coreFoundationKit)
    ]
)
