import SwiftUI

struct TimerConfigurationView: View {
    @ObservedObject var presenter: TimerConfigurationPresenter
    @State private var selectedInterval: String = ""
    @State private var timerDisplay: String = "00:00" // Initial timer display set to 0:00
    @State private var elapsedTime: Int = 0 // Elapsed time in seconds
    @State private var timer: Timer? = nil // Timer object to handle the countdown
    @State private var isPaused: Bool = false // State to track whether the timer is paused

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.92, blue: 0.94) // Background color
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Integrate the PagingControlView
                    PagingControlView(presenter: presenter)

                    Divider().padding(.vertical)

                    // Integrate the ConfigurationDetailsView
                    ConfigurationDetailsView(configuration: presenter.getCurrentConfiguration())

                    // Integrate the IntervalPickerView
                    IntervalPickerView(selectedInterval: $selectedInterval, interval: presenter.currentInterval)

                    // Integrate the TimerControlsView with start, reset, and pause actions
                    TimerControlsView(timerDisplay: $timerDisplay,
                                      startTimerAction: startTimer,
                                      resetTimerAction: resetTimer,
                                      pauseTimerAction: pauseTimer,
                                      isPaused: $isPaused)

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
        timer?.invalidate() // Stop any existing timer
        isPaused = false // Set paused state to false when starting the timer
        elapsedTime = 0
        updateTimerDisplay()

        // Create a new timer that fires every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !isPaused && elapsedTime < 30 {
                elapsedTime += 1
                updateTimerDisplay()
            } else if elapsedTime >= 30 {
                timer?.invalidate() // Stop the timer when it reaches 30 seconds
            }
        }
    }

    // Function to reset the timer to 00:00
    private func resetTimer() {
        timer?.invalidate() // Stop the timer if it's running
        elapsedTime = 0
        isPaused = false // Reset the pause state
        updateTimerDisplay() // Reset the timer display to 00:00
    }

    // Function to pause or resume the timer
    private func pauseTimer() {
        isPaused.toggle()
    }

    // Function to update the timer display
    private func updateTimerDisplay() {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        timerDisplay = String(format: "%02d:%02d", minutes, seconds)
    }
}
