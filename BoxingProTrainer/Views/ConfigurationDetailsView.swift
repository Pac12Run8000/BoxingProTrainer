import SwiftUI

struct ConfigurationDetailsView: View {
    let configuration: Configuration

    var body: some View {
        VStack(alignment: .leading) {
            Text(configuration.title)
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 5)

            Text(configuration.description)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            NavigationLink(destination: DetailsView(configuration: configuration)) {
                Text("More Details")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 1.0, green: 0.55, blue: 0.2)) // Muted orange color
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(red: 0.3, green: 0.35, blue: 0.4)) // Dark gray card-like background
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
