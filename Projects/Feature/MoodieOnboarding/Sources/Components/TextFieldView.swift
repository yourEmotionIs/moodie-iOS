import SwiftUI

struct TextFieldView: View {
    @FocusState.Binding private var isFocused: Bool
    @Binding private var text: String
    private let placeholder: String
    private let enabled: Bool

    public init(
        isFocused: FocusState<Bool>.Binding,
        text: Binding<String>,
        placeholder: String,
        enabled: Bool
    ) {
        self._isFocused = isFocused
        self._text = text
        self.placeholder = placeholder
        self.enabled = enabled
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                let prompt = Text(placeholder)
                    .foregroundColor(Color.yellow)
                
                TextField("", text: $text, prompt: prompt)
                    .font(.title2)
                    .foregroundColor(Color.pink)
                    .disabled(!enabled)
                
            }
            .padding(.horizontal, 20)
        }
        .background(
            Color.purple
                .opacity(enabled ? 1 : 0.7)
        )
        .cornerRadius(12, corners: .allCorners)
        .focused($isFocused)
    }
}
