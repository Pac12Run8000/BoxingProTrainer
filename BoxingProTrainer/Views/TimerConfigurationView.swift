import SwiftUI

struct TimerConfigurationView: View {
    @ObservedObject var presenter: TimerConfigurationPresenter

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.92, blue: 0.94) // Background color similar to soft gray/blue tone
                    .edgesIgnoringSafeArea(.all)

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
                            .foregroundColor(.black)

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
                    .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray background
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Divider().padding(.vertical)

                    // Display the current configuration's title, description, and button below the paging controls
                    VStack(alignment: .leading) {
                        Text(presenter.getCurrentConfiguration().title)
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)

                        Text(presenter.getCurrentConfiguration().description)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)

                        // "More Details" button using NavigationLink to present the details view
                        NavigationLink(destination: DetailsView(configuration: presenter.getCurrentConfiguration())) {
                            Text("More Details")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 1.0, green: 0.55, blue: 0.2)) // Muted orange color for the button
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray card-like background
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Timer Configuration")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

