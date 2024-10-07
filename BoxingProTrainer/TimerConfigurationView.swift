import SwiftUI

struct TimerConfigurationView: View {
    @State private var currentPage = 1
    private let totalPages = 2

    // Updated titles for the two configurations
    private let configurationTitles = [
        "Anaerobic Lactic Energy System (Glycolytic System)",
        "Aerobic Energy System (Oxidative System)"
    ]
    
    // Updated descriptions for each configuration
    private let configurationDescriptions = [
        """
        This system is predominant in:
        • Middle-distance running (e.g., 400-800 meters)
        • High-intensity interval training (HIIT)
        • Repeated weightlifting sets with moderate to heavy loads
        """,
        """
        It is the predominant energy system used during prolonged endurance activities such as:
        • Long-distance running or cycling
        • Walking or jogging
        • Any sustained physical activity lasting more than 2 minutes
        """
    ]

    var body: some View {
        VStack {
            // Paging controls at the top with arrows and page indicator
            HStack {
                Button(action: {
                    if currentPage > 1 {
                        currentPage -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(currentPage > 1 ? .blue : .gray)
                }
                .disabled(currentPage == 1)

                Spacer()

                Text("Configuration \(currentPage)/\(totalPages)")
                    .font(.headline)

                Spacer()

                Button(action: {
                    if currentPage < totalPages {
                        currentPage += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(currentPage < totalPages ? .blue : .gray)
                }
                .disabled(currentPage == totalPages)
            }
            .padding()

            Divider().padding(.vertical)

            // Display content for the current configuration with dynamic headers
            VStack(alignment: .leading) {
                Text(configurationTitles[currentPage - 1])
                    .font(.title2)
                    .padding(.bottom, 5)

                Text(configurationDescriptions[currentPage - 1])
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    TimerConfigurationView()
}
