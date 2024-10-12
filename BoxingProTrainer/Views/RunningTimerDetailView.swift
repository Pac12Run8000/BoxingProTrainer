import SwiftUI

struct RunningTimerDetailView: View {
    let selectedInterval: String // Property to hold the selected interval

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.92, blue: 0.94) // General background color for the view
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Running Timer Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()

                Text("Selected Rest Interval: \(selectedInterval)") // Display the selected interval for rest
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()

                List(0..<40) { index in
                    if index % 2 == 0 {
                        // "Exercise time" with color reflecting the app's dark gray-blue tone
                        Text("\(index + 1). Exercise time - 1 minute")
                            .font(.body)
                            .foregroundColor(.white) // White text for contrast
                            .padding()
                            .frame(maxWidth: .infinity) // Full-width
                            .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray-blue background
                            .cornerRadius(8)
                    } else {
                        // "Rest time" with color reflecting the app's orange accent
                        Text("Rest time - \(selectedInterval)")
                            .font(.body)
                            .foregroundColor(.white) // White text for contrast
                            .padding()
                            .frame(maxWidth: .infinity) // Full-width
                            .background(Color(red: 1.0, green: 0.55, blue: 0.2)) // Orange background
                            .cornerRadius(8)
                    }
                }
                .listStyle(PlainListStyle()) // Keeping it simple and clean

                Spacer()
            }
        }
        .navigationTitle("Running Timer")
        .navigationBarTitleDisplayMode(.inline)
    }
}
