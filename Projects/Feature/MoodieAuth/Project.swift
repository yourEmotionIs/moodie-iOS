//
//  Project.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/10/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    target: .moodieAuth,
    dependencies: [
        .core(target: .coreFoundationKit),
        .core(target: .coreAuthKit),
        .core(target: .coreUIKit)
    ]
)
