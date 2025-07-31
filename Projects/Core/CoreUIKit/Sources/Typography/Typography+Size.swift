//
//  Typography+Size.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/21.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit

extension Typography {
    public enum Size: CGFloat {
        case size24 = 24
        case size22 = 22
        case size16 = 16
        case size15 = 15
        case size17 = 17
    }
}

extension Typography.Size {
    public var lineHeight: CGFloat {
        switch self {
        case .size24:
            return 32
        case .size22:
            return 27
        case .size16:
            return 22
        case .size15:
            return 22
        case .size17:
            return 18
        }
    }
}
