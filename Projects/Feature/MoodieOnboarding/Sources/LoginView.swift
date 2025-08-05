import SwiftUI

struct LoginView: View {
    @State private var currentPage = 0
    private let imageNames = ["onboarding1", "onboarding2", "onboarding3"]

    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.top, 20)
            
            imagePagerView
                .frame(height: 480)
                .padding(.top, 20)
            
            pageControlView
                .padding(.top, 12)
            
            Spacer()
            
            kakaoLoginButton
                .padding(.horizontal, 24)
            
            appleLoginButton
                .padding(.horizontal, 24)
                .padding(.top, 8)
            
            loginHelpLinkButton
                .padding(.top, 12)
                .padding(.bottom, 20)
        }
    }

    // MARK: - 헤더 타이틀 뷰
    private var titleView: some View {
        HStack {
            Text("Moodie")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
        }
    }

    // MARK: - 이미지 슬라이드 뷰
    private var imagePagerView: some View {
        TabView(selection: $currentPage) {
            ForEach(imageNames.indices, id: \.self) { index in
                if let uiImage = UIImage(named: imageNames[index]) {
                    onboardingImage(uiImage: uiImage, index: index)
                } else {
                    placeholderView(index: index)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    private func onboardingImage(uiImage: UIImage, index: Int) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(24)
            .padding(.horizontal, 24)
            .tag(index)
    }
    
    private func placeholderView(index: Int) -> some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.gray.opacity(0.3))
            .padding(.horizontal, 24)
            .tag(index)
    }

    // MARK: - 페이지 컨트롤
    private var pageControlView: some View {
        HStack(spacing: 8) {
            ForEach(imageNames.indices, id: \.self) { index in
                pageIndicatorView(pageNum: index)
            }
        }
    }
    
    private func pageIndicatorView(pageNum: Int) -> some View {
        Circle()
            .fill(pageNum == currentPage ? Color.purple : Color.purple.opacity(0.3))
            .frame(width: 8, height: 8)
    }

    // MARK: - 카카오 로그인 버튼
    private var kakaoLoginButton: some View {
        Button(action: {
            // TODO: - 카카오 로그인 액션
        }) {
            HStack {
                Image(systemName: "message.fill")
                
                Text("카카오로 시작하기")
                    .fontWeight(.medium)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.yellow)
            .cornerRadius(8)
        }
    }
    
    // MARK: - 애플 로그인 버튼
    private var appleLoginButton: some View {
        Button(action: {
            // TODO: 애플 로그인 액션
        }) {
            HStack {
                Image(systemName: "apple.logo")

                Text("Apple로 로그인")
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .cornerRadius(8)
        }
    }

    // MARK: - 하단 도움 링크 버튼
    private var loginHelpLinkButton: some View {
        Button(action: {
            // TODO: - 도움말 액션
        }) {
            Text("로그인에 어려움이 있나요?")
                .foregroundColor(.gray)
                .font(.footnote)
        }
    }
}

#Preview {
    LoginView()
}
