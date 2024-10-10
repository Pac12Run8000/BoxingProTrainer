import SwiftUI

struct TimerControlsView: View {
    @Binding var timerDisplay: String
    let startTimerAction: () -> Void
    let resetTimerAction: () -> Void

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
        }
    }
}

