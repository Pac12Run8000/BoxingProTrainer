import SwiftUI

struct TimerConfigurationView: View {
    @ObservedObject var presenter: TimerConfigurationPresenter
    @State private var selectedInterval: String = ""
    @State private var timerDisplay: String = "00:00" // Initial timer display set to 0:00
    @State private var elapsedTime: Int = 0 // Elapsed time in seconds
    @State private var timer: Timer? = nil // Timer object to handle the countdown

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
                            .foregroundColor(.black)

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

                        NavigationLink(destination: DetailsView(configuration: presenter.getCurrentConfiguration())) {
                            Text("More Details")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 1.0, green: 0.55, blue: 0.2)) // Muted orange color
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray card-like background
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // Interval Dropdown based on the current configuration
                    VStack(alignment: .leading) {
                        Text(presenter.currentInterval.title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.bottom, 5)

                        Picker("Select Interval", selection: $selectedInterval) {
                            ForEach(presenter.currentInterval.options, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Use a dropdown menu style
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Start Timer button
                    Button(action: {
                        startTimer()
                    }) {
                        Text("Start Timer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green) // Green color for the start button
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Timer display beneath the Start Timer button
                    Text(timerDisplay)
                        .font(.system(size: 48, weight: .bold, design: .default)) // Increased font size for timer display
                        .foregroundColor(.black)
                        .padding(.top, 20)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Timer Configuration")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Function to start the count-up timer
    private func startTimer() {
        // Invalidate any existing timer before starting a new one
        timer?.invalidate()
        
        // Reset elapsed time to 0 seconds
        elapsedTime = 0
        updateTimerDisplay()

        // Create a new timer that fires every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if elapsedTime < 30 {
                elapsedTime += 1
                updateTimerDisplay()
            } else {
                timer?.invalidate() // Stop the timer when it reaches 30 seconds
            }
        }
    }

    // Function to update the timer display
    private func updateTimerDisplay() {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        timerDisplay = String(format: "%02d:%02d", minutes, seconds)
    }
}

