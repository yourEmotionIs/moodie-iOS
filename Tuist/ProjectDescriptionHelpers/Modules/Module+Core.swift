//
//  Module+Core.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/8/25.
//

import Foundation
import ProjectDescription

public extension Module {
    enum Core: String {
        case coreFoundationKit = "CoreFoundationKit"
        case coreUIKit = "CoreUIKit"
        case coreAuthKit = "CoreAuthKit"
        
        var infoPlist: InfoPlist {
            switch self {
            case .coreFoundationKit, .coreAuthKit:
                return .default
            case .coreUIKit:
                return .extendingDefault(
                    with: [
                        "UIAppFonts": [
                            "NanumSquareRoundB.ttf",
                        ]
                    ]
                )
            }
        }
        
        var hasResource: Bool {
            switch self {
            case .coreFoundationKit, .coreAuthKit:
                return false
            case .coreUIKit:
                return true
            }
        }
    }
}
