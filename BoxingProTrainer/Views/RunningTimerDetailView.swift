import SwiftUI
import AVFoundation

struct RunningTimerDetailView: View {
    let selectedInterval: String // Property to hold the selected rest interval
    @State private var numberOfRounds: Int = 0 // State to track the number of rounds
    @State private var isRunning: Bool = false // State to toggle between 'Start' and 'Stop'
    @State private var countdown: Int? = nil // Countdown state (nil means no countdown is active)
    @State private var exerciseTimeLeft: Int? = nil // State for exercise time countdown
    @State private var restTimeLeft: Int? = nil // State for rest time countdown
    @State private var currentRound: Int = 0 // Track the current round
    @State private var isExercise: Bool = true // Track if we're in the exercise or rest period
    @State var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.92, blue: 0.94) // Background color to match the main view
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Running Timer Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()

                // Group the round selector, Exercise, and Rest times inside a bordered container
                VStack(spacing: 20) {
                    // Stepper for selecting the number of rounds
                    HStack {
                        Text("How many rounds:")
                            .font(.title3)
                            .foregroundColor(.black)

                        Stepper(value: $numberOfRounds, in: 0...100) {
                            Text("\(numberOfRounds)") // Display the current number of rounds
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                    }
                    .padding()

                    // Display the current round
                    if currentRound > 0 {
                        Text("Current Round: \(currentRound) / \(numberOfRounds)")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 5)
                    }

                    // Exercise Time
                    VStack {
                        Text("Exercise time - \(formattedTime(for: exerciseTimeLeft ?? 60))")
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // Full-width row
                            .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray-blue background
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    // Rest Time
                    VStack {
                        Text("Rest time - \(formattedTime(for: restTimeLeft ?? timeIntervalInSeconds()))")
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // Full-width row
                            .background(Color(red: 1.0, green: 0.55, blue: 0.2)) // Orange background
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white) // White background for the bordered group
                .cornerRadius(10) // Rounded corners
                .shadow(radius: 5) // Optional shadow for elevation
                .overlay( // Border overlay
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2) // Gray border
                )
                .padding(.horizontal)

                Spacer(minLength: 40) // Creates space between the sections

                // Start/Stop Button
                Button(action: {
                    if numberOfRounds > 0 { // Check if the number of rounds is greater than 0
                        if !isRunning {
                            startCountdown()
                        } else {
                            isRunning.toggle() // Stop the timer
                            playSound(soundName: "stop") // Play stop sound
                        }
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start") // Switch button label
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRunning ? Color.red : (numberOfRounds > 0 ? Color.green : Color.gray)) // Red for 'Stop', green for 'Start', gray if rounds are 0
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled(numberOfRounds == 0) // Disable button if rounds are set to 0

                // Reset Button
                Button(action: {
                    reset()
                }) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue) // Blue background for reset
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Spacer()
            }

            // Countdown overlay
            if let countdown = countdown {
                ZStack {
                    Color.black.opacity(0.7) // Dark overlay
                        .edgesIgnoringSafeArea(.all)

                    Text("\(countdown)") // Display the countdown number
                        .font(.system(size: 100, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("Running Timer")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Function to start the 10-second countdown
    private func startCountdown() {
        countdown = 10 // Set countdown to 10 seconds
        playSound(soundName: "correctTimer") // Play the sound when countdown starts

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let currentCountdown = countdown, currentCountdown > 0 {
                countdown = currentCountdown - 1 // Decrease the countdown each second
            } else {
                timer.invalidate() // Stop the countdown timer
                countdown = nil // Hide the overlay
                currentRound = 1 // Start with round 1
                startExerciseTimer() // Start the 1-minute exercise timer
            }
        }
    }

    // Function to start the 1-minute exercise timer
    private func startExerciseTimer() {
        exerciseTimeLeft = 60 // Set the exercise time to 1 minute (60 seconds)
        isRunning = true // Set the timer to running
        isExercise = true // Set the state to "exercise"

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let currentExerciseTime = exerciseTimeLeft, currentExerciseTime > 0 {
                exerciseTimeLeft = currentExerciseTime - 1 // Decrease the exercise time each second
            } else {
                timer.invalidate() // Stop the exercise timer
                startRestTimer() // After exercise, start the rest timer
            }
        }
    }

    // Function to start the rest timer
    private func startRestTimer() {
        restTimeLeft = timeIntervalInSeconds() // Set the rest time based on the selected interval
        isExercise = false // Set the state to "rest"

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let currentRestTime = restTimeLeft, currentRestTime > 0 {
                restTimeLeft = currentRestTime - 1 // Decrease the rest time each second
            } else {
                timer.invalidate() // Stop the rest timer
                if currentRound < numberOfRounds {
                    currentRound += 1 // Move to the next round
                    startExerciseTimer() // Start the exercise timer again for the next round
                } else {
                    isRunning = false // All rounds are completed
                    playSound(soundName: "stop") // Play stop sound when all rounds are done
                }
            }
        }
    }

    // Function to reset the number of rounds and stop the timer
    private func reset() {
        numberOfRounds = 0
        currentRound = 0
        isRunning = false
        countdown = nil // Clear any active countdown
        exerciseTimeLeft = nil // Clear exercise time
        restTimeLeft = nil // Clear rest time
        playSound(soundName: "reset") // Play reset sound
    }

    // Function to format time as MM:SS
    private func formattedTime(for seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    // Function to convert the selected interval to seconds
    private func timeIntervalInSeconds() -> Int {
        switch selectedInterval {
        case "1 minute":
            return 60
        case "2 minutes":
            return 120
        default:
            return 60 // Default to 1 minute
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
}
