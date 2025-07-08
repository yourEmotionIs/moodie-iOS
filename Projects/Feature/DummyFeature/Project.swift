//
//  Project.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/8/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    target: .featureDummy,
    dependencies: [
        .core(target: .coreFoundationKit)
    ]
)
