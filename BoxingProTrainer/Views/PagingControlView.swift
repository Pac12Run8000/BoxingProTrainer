import SwiftUI

struct PagingControlView: View {
    @ObservedObject var presenter: TimerConfigurationPresenter

    var body: some View {
        HStack {
            Button(action: {
                if presenter.currentPage > 1 {
                    presenter.currentPage -= 1
                    presenter.updateInterval()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(presenter.currentPage > 1 ? .blue : .gray)
            }
            .disabled(presenter.currentPage == 1)

            Spacer()

            Text("Configuration \(presenter.currentPage)/\(presenter.totalPages)")
                .font(.headline)
                .foregroundColor(.white) // Changed to white

            Spacer()

            Button(action: {
                if presenter.currentPage < presenter.totalPages {
                    presenter.currentPage += 1
                    presenter.updateInterval()
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(presenter.currentPage < presenter.totalPages ? .blue : .gray)
            }
            .disabled(presenter.currentPage == presenter.totalPages)
        }
        .padding()
        .background(Color(red: 0.3, green: 0.35, blue: 0.4))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
