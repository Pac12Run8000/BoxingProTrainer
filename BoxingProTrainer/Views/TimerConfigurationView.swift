import SwiftUI

struct TimerConfigurationView: View {
    @ObservedObject var presenter: TimerConfigurationPresenter

    var body: some View {
        VStack {
            // Paging controls remain at the top of the view
            HStack {
                Button(action: {
                    if presenter.currentPage > 1 {
                        presenter.currentPage -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(presenter.currentPage > 1 ? .blue : .gray)
                }
                .disabled(presenter.currentPage == 1)

                Spacer()

                Text("Configuration \(presenter.currentPage)/\(presenter.totalPages)")
                    .font(.headline)

                Spacer()

                Button(action: {
                    if presenter.currentPage < presenter.totalPages {
                        presenter.currentPage += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(presenter.currentPage < presenter.totalPages ? .blue : .gray)
                }
                .disabled(presenter.currentPage == presenter.totalPages)
            }
            .padding()

            Divider().padding(.vertical)

            // Display the current configuration's title and description below the paging controls
            VStack(alignment: .leading) {
                Text(presenter.getCurrentConfiguration().title)
                    .font(.title2)
                    .padding(.bottom, 5)

                Text(presenter.getCurrentConfiguration().description)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}


