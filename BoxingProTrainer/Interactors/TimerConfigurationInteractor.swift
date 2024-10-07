import Foundation

protocol TimerConfigurationInteractorProtocol {
    func fetchConfigurations() -> [Configuration]
}

class TimerConfigurationInteractor: TimerConfigurationInteractorProtocol {
    func fetchConfigurations() -> [Configuration] {
        return [
            Configuration(
                title: "Anaerobic Lactic Energy System (Glycolytic System)",
                description: """
                This system is predominant in:
                • Middle-distance running (e.g., 400-800 meters)
                • High-intensity interval training (HIIT)
                • Repeated weightlifting sets with moderate to heavy loads
                """
            ),
            Configuration(
                title: "Aerobic Energy System (Oxidative System)",
                description: """
                It is the predominant energy system used during prolonged endurance activities such as:
                • Long-distance running or cycling
                • Walking or jogging
                • Any sustained physical activity lasting more than 2 minutes
                """
            )
        ]
    }
}
