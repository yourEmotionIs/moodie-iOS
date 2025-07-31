//
//  Target+Templates.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/8/25.
//

import ProjectDescription

public extension Target {
    static func makeAppTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: "com.mumu.\(name).app",
            deploymentTargets: .iOS(Project.depolymentTarget),
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": "LaunchScreen.storyboard",
                "CFBundleShortVersionString": "1.0.0",
                "CFBundleVersion": "1",
                "NSAppTransportSecurity": [ "NSAllowsArbitraryLoads": true ],
                "UIApplicationSceneManifest": [
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": []
                    ]
                ],
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth" // 카카오톡으로 로그인
                ],
                "CFBundleURLTypes": [
                    // Apple 로그인
                    [
                        "CFBundleURLName": "AppleSignIn",
                        "CFBundleURLSchemes": ["com.\(name).app"],
                        "CFBundleURLRole": "Editor"
                    ],
                    // 카카오 로그인
                    [
                        "CFBundleURLName": "KakaoLogin",
                        "CFBundleURLSchemes": ["kakaoc6e355b541377b0886d546a44fc76f50"], // 실제 카카오 앱 키
                        "CFBundleURLRole": "Editor"
                    ]
                ]
            ]),
            sources: ["Sources/**"],
            entitlements: .dictionary([
                "com.apple.developer.applesignin": .array([.string("Default")])
            ]),
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "DEVELOPMENT_TEAM": "7W64WHVKVN",
                    "CODE_SIGN_STYLE": "Automatic"
                ]
            )
        )
    }
    
    static func makeCoreTarget(
        name: String,
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        hasResource: Bool = false
    ) -> Target{
        return .target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.\(name).core",
            deploymentTargets: .iOS(Project.depolymentTarget),
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            entitlements: .dictionary([
                "com.apple.developer.applesignin": .array([.string("Default")])
            ]),
            dependencies: dependencies
        )
    }
    
    static func makeFeatureTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target{
        return .target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.\(name).feature",
            deploymentTargets: .iOS(Project.depolymentTarget),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "DEVELOPMENT_TEAM": "7W64WHVKVN",
                    "CODE_SIGN_STYLE": "Automatic"
                ]
            )
        )
    }
    
    static func makeInterfaceTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.\(name).interface",
            deploymentTargets: .iOS(Project.depolymentTarget),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: dependencies
        )
    }
    
    static func makeFeatureTestingTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.\(name).testing",
            deploymentTargets: .iOS(Project.depolymentTarget),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "DEVELOPMENT_TEAM": "7W64WHVKVN",
                    "CODE_SIGN_STYLE": "Automatic"
                ]
            )
        )
    }
    
    static func makeFeatureTestsTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.\(name).tests",
            deploymentTargets: .iOS(Project.depolymentTarget),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: dependencies
        )
    }
    
    static func makeFeatureExampleTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: "com.\(name).example.app",
            deploymentTargets: .iOS(Project.depolymentTarget),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "DEVELOPMENT_TEAM": "7W64WHVKVN",
                    "CODE_SIGN_STYLE": "Automatic"
                ]
            )
        )
    }

}
