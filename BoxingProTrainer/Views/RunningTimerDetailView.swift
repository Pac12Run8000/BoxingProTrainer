import SwiftUI

struct RunningTimerDetailView: View {
    let selectedInterval: String // Property to hold the selected interval
    @State private var numberOfRounds: Int = 0 // State to track the number of rounds

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

                Spacer()
            }
        }
        .navigationTitle("Running Timer")
        .navigationBarTitleDisplayMode(.inline)
    }
}
