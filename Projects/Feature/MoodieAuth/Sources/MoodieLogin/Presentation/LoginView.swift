import SwiftUI

struct LoginView: View {
    @State private var currentIndex = 0

    private let images = ["image1", "image2", "image3"] // 실제 이미지 이름으로 교체

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)

            // 상단 타이틀
            HStack {
                Text("Moodie")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
            }

            // 이미지 슬라이드 영역
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Text("이미지 \(index + 1)")
                                .foregroundColor(.white)
                        )
                        .padding(.horizontal, 24)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 350)
            .padding(.top, 20)

            // 페이지 인디케이터
            HStack(spacing: 8) {
                ForEach(images.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.purple : Color.purple.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 12)

            Spacer()

            // 카카오 로그인 버튼
            Button(action: {
                // 카카오 로그인 액션
            }) {
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.black)
                    Text("카카오로 시작하기")
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow)
                .cornerRadius(8)
            }
            .padding(.horizontal, 24)

            // Apple 로그인 버튼
            SignInWithAppleButton()
                .frame(height: 50)
                .cornerRadius(8)
                .padding(.horizontal, 24)
                .padding(.top, 8)

            // 하단 도움 링크
            Button(action: {
                // 도움말 액션
            }) {
                Text("로그인에 어려움이 있나요?")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            .padding(.top, 12)

            Spacer().frame(height: 20)
        }
    }
}

// 기본 Apple 로그인 버튼 스타일
struct SignInWithAppleButton: View {
    var body: some View {
        HStack {
            Image(systemName: "apple.logo")
                .foregroundColor(.white)
            Text("Apple로 로그인")
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black)
    }
}

//#Preview {
//    LoginView()
//}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
