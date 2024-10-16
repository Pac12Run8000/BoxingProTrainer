import SwiftUI
import AVFoundation
import UserNotifications

struct TimerConfigurationView: View {
    @ObservedObject var presenter: TimerConfigurationPresenter
    @State private var selectedInterval: String = "" // No default interval set initially
    @State private var timerDisplay: String = "00:00" // Initial timer display set to 0:00
    @State private var elapsedTime: Int = 0 // Elapsed time in seconds
    @State private var timer: Timer? = nil // Timer object to handle the countdown
    @State private var isPaused: Bool = false // State to track whether the timer is paused
    @State private var totalTimeInSeconds: Int = 0 // Initialize with no time set initially
    @State private var backgroundTask: UIBackgroundTaskIdentifier = .invalid // Background task handler
    @State private var audioPlayer: AVAudioPlayer? // Audio player to handle sounds
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.92, blue: 0.94) // Background color
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    PagingControlView(presenter: presenter)
                    
                    Divider().padding(.vertical)
                    
                    ConfigurationDetailsView(configuration: presenter.getCurrentConfiguration())
                    
                    IntervalPickerView(selectedInterval: $selectedInterval, interval: presenter.currentInterval)
                        .onChange(of: selectedInterval) { _ in
                            updateTotalTimeInSeconds() // Update the interval when the dropdown changes
                        }
                    
                    let showRunningTimerButton = presenter.getCurrentConfiguration().title == "Aerobic Energy System (Oxidative System)"
                    
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
            .onAppear {
                setInitialDefaultInterval() // Set the default interval based on the configuration when the view appears
                registerForNotifications()  // Request notification permissions
            }
            .onDisappear {
                // Invalidate background task if app goes into the background
                if backgroundTask != .invalid {
                    UIApplication.shared.endBackgroundTask(backgroundTask)
                    backgroundTask = .invalid
                }
            }
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
        
        // Play the start sound (correctTimer.mp3) when the timer starts
        playSound(soundName: "correctTimer")
        
        // Start background task
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            // End the task if time expires
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
        
        // Create a new timer that fires every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !isPaused && elapsedTime < totalTimeInSeconds {
                elapsedTime += 1
                updateTimerDisplay()
            } else {
                timer?.invalidate() // Stop the timer when it reaches the specified interval
                
                // Play the end sound (endAlert.mp3) when the timer ends
                playSound(soundName: "endAlert")
                
                // End background task when timer completes
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
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
    
    // Function to play a sound
    private func playSound(soundName: String) {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    // Register for notifications and handle background task state
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            saveTimerState()
            scheduleNotification()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            restoreTimerState()
        }
    }
    
    private func saveTimerState() {
        // Save the current elapsedTime and totalTimeInSeconds to UserDefaults or some other persistent store
    }
    
    private func restoreTimerState() {
        // Restore the timer state when coming back to the foreground
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished!"
        content.body = "Your timer has completed."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalTimeInSeconds - elapsedTime), repeats: false)
        let request = UNNotificationRequest(identifier: "TimerNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
