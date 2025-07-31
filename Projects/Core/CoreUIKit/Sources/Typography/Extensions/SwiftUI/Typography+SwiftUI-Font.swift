//
//  Typography+SwiftUI-Font.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
public extension Typography.FontType {
    func createSwiftUIFont(weight: UIFont.Weight, size: CGFloat) -> Font {
        switch self {
        case .appleSDGothic:
            return createAppleSDGothicSwiftUIFont(weight: weight, size: size)
        case .nanumSquareRound:
            return createNanumSquareRoundSwiftUIFont(weight: weight, size: size)
        case .suit:
            return createSuitSwiftUIFont(weight: weight, size: size)
        }
    }
    
    private func createAppleSDGothicSwiftUIFont(weight: UIFont.Weight, size: CGFloat) -> Font {
        let fontName = appleSDGothicFontName(for: weight)
        return Font.custom(fontName, size: size)
    }
    
    private func createNanumSquareRoundSwiftUIFont(weight: UIFont.Weight, size: CGFloat) -> Font {
        let fontName: String
        switch weight {
        case .heavy:
            fontName = "NanumSquareRoundOTFEB" // ExtraBold
        case .bold:
            fontName = "NanumSquareRoundOTFB"  // Bold
        case .regular:
            fontName = "NanumSquareRoundOTFR"  // Regular
        case .light:
            fontName = "NanumSquareRoundOTFL"  // Light
        default:
            fontName = "NanumSquareRoundOTFR"  // Regular
        }
        return Font.custom(fontName, size: size)
    }
    
    private func createSuitSwiftUIFont(weight: UIFont.Weight, size: CGFloat) -> Font {
        let fontName: String
        switch weight {
        case .heavy:
            fontName = "SUIT-ExtraBold"
        case .bold:
            fontName = "SUIT-Bold"
        case .semibold:
            fontName = "SUIT-SemiBold"
        case .medium:
            fontName = "SUIT-Medium"
        case .regular:
            fontName = "SUIT-Regular"
        case .light:
            fontName = "SUIT-Light"
        default:
            fontName = "SUIT-Regular"
        }
        return Font.custom(fontName, size: size)
    }
    
    private func appleSDGothicFontName(for weight: UIFont.Weight) -> String {
        switch weight {
        case .bold: return "AppleSDGothicNeo-Bold"
        case .semibold: return "AppleSDGothicNeo-SemiBold"
        case .medium: return "AppleSDGothicNeo-Medium"
        case .light: return "AppleSDGothicNeo-Light"
        default: return "AppleSDGothicNeo-Regular"
        }
    }
}
