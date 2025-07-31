//
//  TypoExampleView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import SwiftUI

// MARK: - Usage Examples

#if DEBUG
@available(iOS 14.0, *)
struct TypographyExamples: View {
    @State private var textFieldText = ""
    @State private var secureFieldText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, SwiftUI!", typography: Typography(
                fontType: .appleSDGothic, // 생략 가능
                size: .size24,
                weight: .bold,
                color: .gray1
            ))
            
            Text("나눔스퀘어라운드", typography: Typography(
                fontType: .nanumSquareRound,
                size: .size22,
                weight: .bold,
                color: .red
            ))
            
            Text("SUIT Font", typography: Typography(
                fontType: .suit,
                size: .size17,
                weight: .semibold,
                color: .green
            ))
            
            TextField("Enter text", text: $textFieldText)
                .typography(Typography(
                    fontType: .appleSDGothic,
                    size: .size16,
                    weight: .regular,
                    color: .black
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $secureFieldText)
                .typography(Typography(
                    fontType: .suit,
                    size: .size16,
                    weight: .regular,
                    color: .black
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Tap me", typography: Typography(
                fontType: .nanumSquareRound,
                size: .size15,
                weight: .semibold,
                color: .white
            )) {
                print("Button tapped")
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            
            Label("Settings", systemImage: "gear", typography: Typography(
                fontType: .suit,
                size: .size16,
                weight: .medium,
                color: .gray
            ))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .typography(Typography(
                        fontType: .appleSDGothic,
                        size: .size24,
                        weight: .bold,
                        color: .black
                    ))
                
                Text("Subtitle with line height applied")
                    .typography(Typography(
                        fontType: .nanumSquareRound,
                        size: .size22,
                        weight: .regular,
                        color: .gray,
                        applyLineHeight: true
                    ))
                
                Text("SUIT 폰트 예시")
                    .typography(Typography(
                        fontType: .suit,
                        size: .size17,
                        weight: .light,
                        color: .blue,
                        applyLineHeight: true
                    ))
            }
        }
        .padding()
    }
}

@available(iOS 14.0, *)
struct TypographyExamples_Previews: PreviewProvider {
    static var previews: some View {
        TypographyExamples()
    }
}
#endif
