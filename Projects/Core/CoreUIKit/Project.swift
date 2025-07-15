//
//  Project.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/10/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeCoreModule(
    target: .coreUIKit,
    dependencies: [
        .thirdParty(target: .combineCocoa),
        .thirdParty(target: .rxSwift),
        .thirdParty(target: .rxCocoa),
        .thirdParty(target: .snapKit),
        .thirdParty(target: .then)
    ]
)

