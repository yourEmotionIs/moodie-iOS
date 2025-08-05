import SwiftUI

struct PartnerSelectionView: View {
    @State private var isPresented: Bool = false
    private let partnerTypeItems: [PartnerType.CheckItem]
    
    init(partnerTypeItems: [PartnerType.CheckItem]) {
        self.partnerTypeItems = partnerTypeItems
    }

    var body: some View {
        VStack(alignment: .leading) {
            navigationView
                .padding(.top, 0)
                .padding(.leading, 8)
                .padding(.trailing, 20)
            
            titleView
                .padding(.horizontal, 20)
                .padding(.top, 15)
            
            contentView
                .padding(.top, 15)
            
            Spacer()
            
            nextButton
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
        .background(Color.purple)
        .edgesIgnoringSafeArea(.bottom)
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
        Text("누구와 함께 사용하나요")
            .font(.title3.bold())
            .border(.blue, width: 1)
    }
    
    private var contentView: some View {
        HStack(spacing: 0) {
            ForEach(partnerTypeItems) { item in
                PartnerOptionItemView(item: item, action: {
                    isPresented = item.isChecked
                })
            }
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            // TODO: - 다음 화면으로 이동
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
        .disabled(isPresented == false)
    }
    
    private var nextButtonOpacity: Double {
        isPresented ? 1.0 : 0.24
    }
}

private struct PartnerOptionItemView: View {
    private let item: PartnerType.CheckItem
    private let action: () -> Void
    
    init(
        item: PartnerType.CheckItem,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 8) {
                characterImage
                
                partnerName
            }
            .padding()
            .frame(width: 120, height: 140)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(item.isChecked ? Color.purple.opacity(0.6) : Color.clear, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
            )
        }
    }
    
    private var characterImage: some View {
        Image(item.type.imageName)
            .resizable()
            .frame(
                width: 120,
                height: 120
            )
    }
    
    private var partnerName: some View {
        Text(item.type.name)
            .font(.subheadline)
            .foregroundColor(.black)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerSelectionView(partnerTypeItems: [.init(type: .boyfriend), .init(type: .girlfriend)])
    }
}
