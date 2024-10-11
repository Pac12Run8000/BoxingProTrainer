import SwiftUI

struct TimerConfigurationView: View {
    @ObservedObject var presenter: TimerConfigurationPresenter
    @State private var selectedInterval: String = "" // No default interval set initially
    @State private var timerDisplay: String = "00:00" // Initial timer display set to 0:00
    @State private var elapsedTime: Int = 0 // Elapsed time in seconds
    @State private var timer: Timer? = nil // Timer object to handle the countdown
    @State private var isPaused: Bool = false // State to track whether the timer is paused
    @State private var totalTimeInSeconds: Int = 0 // Initialize with no time set initially

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
                        .onChange(of: selectedInterval) { _ in
                            updateTotalTimeInSeconds() // Update the interval when the dropdown changes
                        }

                    // Determine if the "Display Running Timer" button should be shown based on the configuration
                    let showRunningTimerButton = presenter.getCurrentConfiguration().title == "Aerobic Energy System (Oxidative System)"

                    // Integrate the TimerControlsView with start, reset, pause, and running timer actions
                    TimerControlsView(timerDisplay: $timerDisplay,
                                      startTimerAction: startTimer,
                                      resetTimerAction: resetTimer,
                                      pauseTimerAction: togglePauseResumeTimer,
                                      isPaused: $isPaused,
                                      showRunningTimerButton: showRunningTimerButton,
                                      selectedInterval: selectedInterval)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Timer Configuration")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            setInitialDefaultInterval() // Set the default interval based on the configuration when the view appears
        }
        .onChange(of: presenter.currentPage) { _ in
            setInitialDefaultInterval() // Update the default interval when the configuration changes
        }
    }

    // Function to set the initial default interval based on the current configuration
    private func setInitialDefaultInterval() {
        let currentConfiguration = presenter.getCurrentConfiguration().title
        if currentConfiguration == "Anaerobic Lactic Energy System (Glycolytic System)" {
            selectedInterval = "30 seconds"
            totalTimeInSeconds = 30
        } else if currentConfiguration == "Aerobic Energy System (Oxidative System)" {
            selectedInterval = "1 minute"
            totalTimeInSeconds = 60
        }
    }

    // Function to start or resume the timer
    private func startTimer() {
        timer?.invalidate() // Stop any existing timer
        isPaused = false // Set paused state to false when starting or resuming the timer

        // Create a new timer that fires every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !isPaused && elapsedTime < totalTimeInSeconds {
                elapsedTime += 1
                updateTimerDisplay()
            } else {
                timer?.invalidate() // Stop the timer when it reaches the specified interval
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

    // Function to toggle pause or resume state
    private func togglePauseResumeTimer() {
        isPaused.toggle()
        if !isPaused {
            startTimer() // Resume the timer if it's not paused
        } else {
            timer?.invalidate() // Pause the timer
        }
    }

    // Function to update the timer display
    private func updateTimerDisplay() {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        timerDisplay = String(format: "%02d:%02d", minutes, seconds)
    }

    // Function to update the total time in seconds based on the selected interval
    private func updateTotalTimeInSeconds() {
        switch selectedInterval {
        case "30 seconds":
            totalTimeInSeconds = 30
        case "45 seconds":
            totalTimeInSeconds = 45
        case "1 minute":
            totalTimeInSeconds = 60
        case "1 minute 30 seconds":
            totalTimeInSeconds = 90
        case "2 minutes":
            totalTimeInSeconds = 120
        default:
            totalTimeInSeconds = 0
        }
    }
}
