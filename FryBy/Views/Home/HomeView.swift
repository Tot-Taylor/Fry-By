import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                FryTheme.backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 18) {
                        Text("🍟")
                            .font(.system(size: 86))
                            .shadow(color: FryTheme.fry.opacity(0.45), radius: 24, x: 0, y: 10)

                        VStack(spacing: 8) {
                            Text("Fry-By")
                                .font(.system(size: 46, weight: .black, design: .rounded))
                                .foregroundStyle(FryTheme.text)
                            Text("French Fry Ratings")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(FryTheme.mutedText)
                        }
                    }
                    .padding(28)
                    .background(
                        RoundedRectangle(cornerRadius: 34, style: .continuous)
                            .fill(FryTheme.card.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 34, style: .continuous)
                                    .stroke(FryTheme.cardStroke.opacity(0.9), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)

                    Spacer()

                    VStack(spacing: 12) {
                        NavigationLink(destination: EntryListView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "list.bullet.clipboard")
                                Text("My Fry Log")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(FryTheme.fryGradient)
                            .foregroundStyle(Color(red: 0.14, green: 0.08, blue: 0.02))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: FryTheme.fry.opacity(0.35), radius: 18, x: 0, y: 10)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 52)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
