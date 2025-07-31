//
//  Project.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/10/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeCoreModule(
    target: .coreAuthKit,
    dependencies: [
        .thirdParty(target: .kakaoSDKAuth),
        .thirdParty(target: .kakaoSDKCommon),
        .thirdParty(target: .kakaoSDKUser),
    ]
)

