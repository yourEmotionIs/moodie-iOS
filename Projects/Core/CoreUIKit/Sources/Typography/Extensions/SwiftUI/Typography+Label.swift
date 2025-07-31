//
//  Typography+Label.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import SwiftUI

@available(iOS 14.0, *)
public extension Label where Title == Text, Icon == Image {
    /// Typography를 적용한 Label 생성
    init<S>(_ title: S, systemImage: String, typography: Typography) where S : StringProtocol {
        self.init {
            Text(title)
                .typography(typography)
        } icon: {
            Image(systemName: systemImage)
        }
    }
    
    init(_ titleKey: LocalizedStringKey, systemImage: String, typography: Typography) {
        self.init {
            Text(titleKey)
                .typography(typography)
        } icon: {
            Image(systemName: systemImage)
        }
    }
}
