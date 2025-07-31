//
//  Module+ThirdParty.swift
//  MoodieManifests
//
//  Created by 이숭인 on 7/8/25.
//

import Foundation

public extension Module {
    enum ThirdParty: String {
        case snapKit = "SnapKit"
        case then = "Then"
        case combineCocoa = "CombineCocoa"
        case combineExt = "CombineExt"
        case rxSwift = "RxSwift"
        case rxCocoa = "RxCocoa"
        case realm = "Realm"
        case realmSwift = "RealmSwift"
        case quick = "Quick"
        case nimble = "Nimble"
        
        case kakaoSDKCommon = "KakaoSDKCommon"
        case kakaoSDKAuth = "KakaoSDKAuth"
        case kakaoSDKUser = "KakaoSDKUser"
    }
}
