import SwiftUI

struct TimerControlsView: View {
    @Binding var timerDisplay: String
    let startTimerAction: () -> Void
    let resetTimerAction: () -> Void
    let pauseTimerAction: () -> Void
    @Binding var isPaused: Bool
    let showRunningTimerButton: Bool // New parameter to control button visibility
    let selectedInterval: String // New parameter for the selected interval

    var body: some View {
        VStack {
            Button(action: startTimerAction) {
                Text("Start Timer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Text(timerDisplay)
                .font(.system(size: 48, weight: .bold, design: .default))
                .foregroundColor(.black)
                .padding(.top, 20)

            // Reset Timer button
            Button(action: resetTimerAction) {
                Text("Reset Timer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red) // Red color for the reset button
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // Pause Timer button
            Button(action: pauseTimerAction) {
                Text(isPaused ? "Resume Timer" : "Pause Timer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange) // Orange color for the pause button
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // Display Running Timer button, only visible in the second configuration
            if showRunningTimerButton {
                NavigationLink(destination: RunningTimerDetailView(selectedInterval: selectedInterval)) {
                    Text("Display Running Timer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue) // Blue color for the running timer button
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
    }
}
