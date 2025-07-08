//
//  Project.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/8/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeCoreModule(
    target: .coreFoundationKit,
    dependencies: [
        .thirdParty(target: .combineCocoa),
        .thirdParty(target: .rxSwift),
        .thirdParty(target: .rxCocoa),
        .thirdParty(target: .realm),
        .thirdParty(target: .realmSwift)
    ]
)

