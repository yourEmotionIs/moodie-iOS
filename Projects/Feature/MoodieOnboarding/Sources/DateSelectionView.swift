import SwiftUI

struct DateSelectionView: View {
    @State private var selectedDate: Date = Date()
    @State private var isDatePickerPresented: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            navigationView
                .padding(.top, 8)
                .padding(.horizontal, 20)

            titleView
                .padding(.top, 32)
                .padding(.horizontal, 20)

            dateFieldView
                .padding(.top, 24)

            Spacer()

            nextButton
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
        .background(Color(hex: "#F7F5FF")) // 배경색
        .edgesIgnoringSafeArea(.bottom)
    }

    private var navigationView: some View {
        HStack {
            Button(action: {
                // TODO: - 뒤로가기 액션
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
            }

            Spacer()

            Text("Onboarding")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            HStack(spacing: 4) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index == 3 ? Color.purple : Color.gray.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }

    private var titleView: some View {
        Text("(상대방의 별명)과 언제부터 만났나요")
            .font(.title3.bold())
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
    }

    private var dateFieldView: some View {
        VStack(spacing: 4) {
            Button {
                isDatePickerPresented.toggle()
            } label: {
                HStack {
                    Text(formattedDate(selectedDate))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }

            Text("오늘까지 D+\(daysFromSelectedDate())일이에요")
                .font(.caption)
                .foregroundColor(.gray)

            if isDatePickerPresented {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 200)
                    .transition(.move(edge: .bottom))
            }
        }
        .padding(.horizontal, 20)
    }

    private var nextButton: some View {
        Button(action: {
            // TODO: - 다음 액션
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.purple.opacity(1.0))

                Text("다음")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 52)
    }

    // MARK: - Helper Methods

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }

    private func daysFromSelectedDate() -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: selectedDate)
        let end = calendar.startOfDay(for: Date())
        return calendar.dateComponents([.day], from: start, to: end).day ?? 0
    }
}

// MARK: - Preview

struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DateSelectionView()
    }
}
