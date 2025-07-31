//
//  Typography+SwiftUI.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public extension Typography {
    /// SwiftUI Font 생성
    var swiftUIFont: Font {
        return fontType.createSwiftUIFont(weight: weight, size: size.rawValue)
    }
    
    /// SwiftUI Color 생성 (UIColor -> Color 변환)
    var swiftUIColor: Color {
        return Color(color)
    }
    
    /// SwiftUI TextAlignment 생성
    var swiftUIAlignment: TextAlignment {
        switch alignment {
        case .left:
            return .leading
        case .center:
            return .center
        case .right:
            return .trailing
        case .justified:
            return .leading // SwiftUI에는 justified가 없으므로 leading 사용
        case .natural:
            return .leading
        @unknown default:
            return .leading
        }
    }
    
    /// 라인 높이를 적용한 line spacing 계산
    var lineSpacing: CGFloat {
        guard applyLineHeight else { return 0 }
        
        // 실제 사용될 폰트의 라인 높이 계산
        let actualFont = fontType.createFont(weight: weight, size: size.rawValue)
        let defaultLineHeight = actualFont.lineHeight
        let customLineHeight = size.lineHeight
        
        return max(0, customLineHeight - defaultLineHeight)
    }
    
    /// iOS 16+ 에서 사용할 수 있는 정확한 라인 높이 설정
    @available(iOS 16.0, *)
    var leading: Font.Leading {
        guard applyLineHeight else { return .standard }
        
        let actualFont = fontType.createFont(weight: weight, size: size.rawValue)
        let defaultLineHeight = actualFont.lineHeight
        let customLineHeight = size.lineHeight
        let additionalSpacing = customLineHeight - defaultLineHeight
        
        if additionalSpacing <= 0 {
            return .tight
        } else if additionalSpacing >= defaultLineHeight * 0.2 {
            return .loose
        } else {
            return .standard
        }
    }
    
    /// AttributedString 생성 (iOS 15+에서 정확한 라인 높이 제어)
    @available(iOS 15.0, *)
    func createAttributedString(for text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        // 폰트 설정
        let uiFont = fontType.createFont(weight: weight, size: size.rawValue)
        attributedString.font = Font(uiFont)
        
        // 색상 설정
        attributedString.foregroundColor = swiftUIColor
        
        // 라인 높이 설정 (applyLineHeight가 true일 때만)
        if applyLineHeight {
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = size.lineHeight
            paragraphStyle.maximumLineHeight = size.lineHeight
            paragraphStyle.alignment = alignment
            
            // 베이스라인 오프셋 계산
            let baselineOffset = (size.lineHeight - uiFont.lineHeight) / 2.0
            
            attributedString.paragraphStyle = paragraphStyle
            attributedString.baselineOffset = baselineOffset
        }
        
        return attributedString
    }
}
