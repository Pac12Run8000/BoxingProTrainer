import SwiftUI

struct IntervalPickerView: View {
    @Binding var selectedInterval: String
    let interval: Interval

    var body: some View {
        VStack(alignment: .leading) {
            Text(interval.title)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 5)

            Picker("Select Interval", selection: $selectedInterval) {
                ForEach(interval.options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
