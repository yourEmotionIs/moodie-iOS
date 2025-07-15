//
//  Typography+Font.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/12/25.
//

import UIKit

extension Typography {
    public enum FontType {
        case appleSDGothic
        case nanumSquareRound
        case suit
        
        func createFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
            switch self {
            case .appleSDGothic:
                return createAppleSDGothicFont(weight: weight, size: size)
            case .nanumSquareRound:
                return createNanumSquareRoundFont(weight: weight, size: size)
            case .suit:
                return createSuitFont(weight: weight, size: size)
            }
        }
        
        private func createAppleSDGothicFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
            let fontName = appleSDGothicFontName(for: weight)
            return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        }
        
        private func createNanumSquareRoundFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
            switch weight {
            case .heavy: return .NanumSquareRound.extraBold.font(size: size)
            case .bold: return .NanumSquareRound.bold.font(size: size)
            case .regular: return .NanumSquareRound.regular.font(size: size)
            case .light: return .NanumSquareRound.light.font(size: size)
            default: return .NanumSquareRound.regular.font(size: size)
            }
        }
        
        private func createSuitFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
            switch weight {
            case .heavy: return .Suit.extraBold.font(size: size)
            case .bold: return .Suit.bold.font(size: size)
            case .semibold: return .Suit.semiBold.font(size: size)
            case .medium: return .Suit.medium.font(size: size)
            case .regular: return .Suit.regular.font(size: size)
            case .light: return .Suit.light.font(size: size)
            default: return .Suit.regular.font(size: size)
            }
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
}
