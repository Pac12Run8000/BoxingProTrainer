import SwiftUI

struct DetailsView: View {
    let configuration: Configuration

    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.92, blue: 0.94) // Background color to match the main view
                .edgesIgnoringSafeArea(.all)

            ScrollView { // Using ScrollView to handle long descriptions
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(configuration.title)
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)

                        Text(configuration.fullDescription)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray background to match main view
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
