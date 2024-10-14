import SwiftUI

struct RunningTimerDetailView: View {
    let selectedInterval: String // Property to hold the selected interval
    @State private var numberOfRounds: Int = 0 // State to track the number of rounds
    @State private var isRunning: Bool = false // State to toggle between 'Start' and 'Stop'
    @State private var countdown: Int? = nil // Countdown state (nil means no countdown is active)

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

                    // Single iteration for Exercise Time
                    VStack {
                        Text("Exercise time - 1 minute")
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // Full-width row
                            .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray-blue background
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    // Single iteration for Rest Time
                    VStack {
                        Text("Rest time - \(selectedInterval)")
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
                    if !isRunning {
                        startCountdown()
                    } else {
                        isRunning.toggle() // Stop the timer
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start") // Switch button label
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRunning ? Color.red : Color.green) // Red for 'Stop', green for 'Start'
                        .cornerRadius(8)
                }
                .padding(.horizontal)

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

    // Function to start the 5-second countdown
    private func startCountdown() {
        countdown = 10 // Set countdown to 5 seconds
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let currentCountdown = countdown, currentCountdown > 0 {
                countdown = currentCountdown - 1 // Decrease the countdown each second
            } else {
                timer.invalidate() // Stop the countdown timer
                countdown = nil // Hide the overlay
                isRunning = true // Start the main timer
            }
        }
    }

    // Function to reset the number of rounds and stop the timer
    private func reset() {
        numberOfRounds = 0
        isRunning = false
        countdown = nil // Clear any active countdown
    }
}
