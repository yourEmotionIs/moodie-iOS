import SwiftUI

struct NicknameInputView: View {
    @State private var nicknameText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    private let partnerType: PartnerType
    private let onBackTapped: () -> Void
    private let onNextTapped: (String) -> Void
    
    init(
        partnerType: PartnerType,
        onBackTapped: @escaping () -> Void = {},
        onNextTapped: @escaping (String) -> Void = { _ in }
    ) {
        self.partnerType = partnerType
        self.onBackTapped = onBackTapped
        self.onNextTapped = onNextTapped
    }
    
    var body: some View {
        VStack(spacing: 20) {
            navigationView
            
            titleView
            
            characterImage
            
            if isTextFieldFocused {
                inputView
                    .padding(.horizontal, 24)
            } else {
                Spacer()
                
                actionButtonView
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
            }
        }
        .background(Color.white)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    private var navigationView: some View {
        HStack {
            backButton
            Spacer()
        }
    }
    
    private var backButton: some View {
        Button(action: {
            // TODO: - 뒤로가기 액션
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
        .frame(width: 40, height: 40)
        .border(.blue, width: 1)
    }
    
    private var titleView: some View {
        Text("애칭을 정해주세요")
            .font(.title3.bold())
            .border(.blue, width: 1)
    }
    
    private var characterImage: some View {
        Image(partnerType.imageName)
            .resizable()
            .frame(
                width: 300,
                height: 300
            )
    }
    
    private var inputView: some View {
        TextFieldView(
            isFocused: $isTextFieldFocused,
            text: $nicknameText,
            placeholder: "플레이스홀더",
            enabled: true
        )
    }
    
    private var actionButtonView: some View {
        Button(action: {
            isTextFieldFocused = false
            // TODO: - 다음 화면으로 이동
            onNextTapped(nicknameText.trimmingCharacters(in: .whitespacesAndNewlines))
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(#colorLiteral(red: 0.67, green: 0.58, blue: 1.0, alpha: 1)))
                    .opacity(nextButtonOpacity)

                Text("다음")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        })
        .frame(height: 52)
        .disabled(nicknameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    
    private var nextButtonOpacity: Double {
        !nicknameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 1.0 : 0.24
    }
}

