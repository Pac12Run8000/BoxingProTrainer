import SwiftUI

struct RunningTimerDetailView: View {
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.92, blue: 0.94) // Background color to match the main view
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Running Timer Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()

                Text("This view displays detailed information about the running timer.")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding()

                Spacer()
            }
        }
        .navigationTitle("Running Timer")
        .navigationBarTitleDisplayMode(.inline)
    }
}
