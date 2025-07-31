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
            case .coreFoundationKit:
                return .default
            case .coreAuthKit:
                return .default
            case .coreUIKit:
                return .extendingDefault(
                    with: [
                        "UIAppFonts": [
                            // NanumSquareRound TTF 폰트들
                            "NanumSquareRoundB.ttf",
                            "NanumSquareRoundEB.ttf",
                            "NanumSquareRoundL.ttf",
                            "NanumSquareRoundR.ttf",
                            
                            // NanumSquareRound OTF 폰트들
                            "NanumSquareRoundOTFB.otf",
                            "NanumSquareRoundOTFEB.otf",
                            "NanumSquareRoundOTFL.otf",
                            "NanumSquareRoundOTFR.otf",
                            
                            // SUIT 폰트들
                            "SUIT-Bold.otf",
                            "SUIT-ExtraBold.otf",
                            "SUIT-ExtraLight.otf",
                            "SUIT-Heavy.otf",
                            "SUIT-Light.otf",
                            "SUIT-Medium.otf",
                            "SUIT-Regular.otf",
                            "SUIT-SemiBold.otf",
                            "SUIT-Thin.otf"
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
