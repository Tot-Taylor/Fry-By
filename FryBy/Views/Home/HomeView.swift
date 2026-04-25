import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    Text("🍟")
                        .font(.system(size: 80))

                    VStack(spacing: 6) {
                        Text("Fry-By")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                        Text("French Fry Ratings")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

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
                        .background(Color.yellow)
                        .foregroundStyle(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 52)
            }
            .navigationBarHidden(true)
        }
    }
}
