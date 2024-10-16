import SwiftUI
import AVFoundation
import UIKit

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
    @State var backgroundTask: UIBackgroundTaskIdentifier = .invalid // For background task handling

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.92, blue: 0.94)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Running Timer Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()

                VStack(spacing: 20) {
                    HStack {
                        Text("Rounds:")
                            .font(.title3)
                            .foregroundColor(.black)

                        Stepper(value: $numberOfRounds, in: 0...100) {
                            Text("\(numberOfRounds)")
                                .font(.title3)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                    }
                    .padding()

                    if currentRound > 0 {
                        Text("Current Round: \(currentRound) / \(numberOfRounds)")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 5)
                    }

                    VStack {
                        Text("Exercise time - \(formattedTime(for: exerciseTimeLeft ?? 60))")
                            .font(.system(size: 28))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.3, green: 0.35, blue: 0.4))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    VStack {
                        Text("Rest time - \(formattedTime(for: restTimeLeft ?? timeIntervalInSeconds()))")
                            .font(.system(size: 28))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 1.0, green: 0.55, blue: 0.2))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding(.horizontal)

                Spacer(minLength: 40)

                Button(action: {
                    if numberOfRounds > 0 {
                        if !isRunning {
                            startCountdown()
                        } else {
                            isRunning.toggle()
                            playSound(soundName: "stop")
                        }
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRunning ? Color.red : (numberOfRounds > 0 ? Color.green : Color.gray))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled(numberOfRounds == 0)

                Button(action: reset) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Spacer()
            }

            if let countdown = countdown {
                ZStack {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)

                    Text("\(countdown)")
                        .font(.system(size: 100, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("Running Timer")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: endBackgroundTask)
    }

    private func startCountdown() {
        countdown = 10
        playSound(soundName: "correctTimer")

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let currentCountdown = countdown, currentCountdown > 0 {
                countdown = currentCountdown - 1
            } else {
                timer.invalidate()
                countdown = nil
                currentRound = 1
                startExerciseTimer()
            }
        }
    }

    private func startExerciseTimer() {
        exerciseTimeLeft = 60
        isRunning = true
        isExercise = true
        beginBackgroundTask()

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let currentExerciseTime = exerciseTimeLeft, currentExerciseTime > 0 {
                exerciseTimeLeft = currentExerciseTime - 1

                if currentExerciseTime == 4 {
                    playSound(soundName: "endAlert")
                }
            } else {
                timer.invalidate()
                startRestTimer()
            }
        }
    }

    private func startRestTimer() {
        restTimeLeft = timeIntervalInSeconds()
        isExercise = false

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let currentRestTime = restTimeLeft, currentRestTime > 0 {
                restTimeLeft = currentRestTime - 1

                if currentRestTime == 4 {
                    playSound(soundName: "endAlert")
                }
            } else {
                timer.invalidate()
                if currentRound < numberOfRounds {
                    currentRound += 1
                    startExerciseTimer()
                } else {
                    isRunning = false
                    playSound(soundName: "stop")
                    endBackgroundTask()
                }
            }
        }
    }

    private func reset() {
        numberOfRounds = 0
        currentRound = 0
        isRunning = false
        countdown = nil
        exerciseTimeLeft = nil
        restTimeLeft = nil
        playSound(soundName: "reset")
    }

    private func formattedTime(for seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    private func timeIntervalInSeconds() -> Int {
        switch selectedInterval {
        case "1 minute": return 60
        case "2 minutes": return 120
        default: return 60
        }
    }

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

    private func beginBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}
