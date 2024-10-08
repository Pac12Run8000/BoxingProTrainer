import SwiftUI

protocol TimerConfigurationInteractorProtocol {
    func fetchConfigurations() -> [Configuration]
    func fetchIntervals(for configurationTitle: String) -> Interval
}

class TimerConfigurationInteractor: TimerConfigurationInteractorProtocol {
    // Fetch the list of configurations with full descriptions
    func fetchConfigurations() -> [Configuration] {
        return [
            Configuration(
                title: "Anaerobic Lactic Energy System (Glycolytic System)",
                description: """
                This system is predominant in:
                • Middle-distance running (e.g., 400-800 meters)
                • High-intensity interval training (HIIT)
                • Repeated weightlifting sets with moderate to heavy loads
                """,
                fullDescription: """
                Duration: 10 seconds to ~2 minutes
                Primary Fuel Source: Glucose
                Intensity: High-intensity, but longer than the alactic system

                The anaerobic lactic system, also known as the glycolytic system, provides energy for high-intensity activities lasting between 10 seconds and 2 minutes. It breaks down glucose (primarily from muscle glycogen stores) to produce ATP without the use of oxygen, resulting in the production of lactic acid (or more accurately, lactate and hydrogen ions).

                This system is predominant in:
                • Middle-distance running (e.g., 400-800 meters)
                • High-intensity interval training (HIIT)
                • Repeated weightlifting sets with moderate to heavy loads

                Mechanism: The anaerobic glycolytic pathway starts with the breakdown of glucose (glycolysis) into pyruvate, which normally enters the mitochondria for aerobic energy production. However, when oxygen is insufficient due to the high-intensity demand, pyruvate is converted to lactate. Lactate buildup is often associated with fatigue and the burning sensation in muscles. While the glycolytic system can produce more ATP than the phosphagen system, it is still relatively inefficient compared to aerobic metabolism, and the accumulation of lactate limits its duration.
                """
            ),
            Configuration(
                title: "Aerobic Energy System (Oxidative System)",
                description: """
                It is the predominant energy system used during prolonged endurance activities such as:
                • Long-distance running or cycling
                • Walking or jogging
                • Any sustained physical activity lasting more than 2 minutes
                """,
                fullDescription: """
                Duration: 2 minutes to several hours
                Primary Fuel Source: Carbohydrates (glucose), fats (fatty acids), and, to a lesser extent, proteins
                Intensity: Low to moderate intensity, sustained activity

                The aerobic system, or oxidative energy system, is the body’s most efficient way of generating ATP for long-duration, lower-intensity activities. Unlike the anaerobic systems, it relies on oxygen to produce energy, which allows it to sustain activity for extended periods. It is the predominant energy system used during prolonged endurance activities such as:
                • Long-distance running or cycling
                • Walking or jogging
                • Any sustained physical activity lasting more than 2 minutes

                Mechanism: In the aerobic system, ATP is produced primarily through the oxidation of carbohydrates and fats in the mitochondria of cells. The key processes involved are:
                • Glycolysis (aerobic breakdown of glucose into pyruvate, followed by its oxidation in the mitochondria).
                • Beta-oxidation (the breakdown of fatty acids for energy).
                • Krebs Cycle and Electron Transport Chain (processes in the mitochondria that generate large amounts of ATP from the breakdown of carbohydrates, fats, and, in rare cases, proteins).

                Because the aerobic system can tap into large stores of energy (carbohydrates and fats), it is highly efficient for sustained activities. However, it cannot produce energy as quickly as the anaerobic systems, which is why it is utilized primarily for lower-intensity, long-duration exercises.
                """
            )
        ]
    }

    // Fetch the interval options based on the configuration title
    func fetchIntervals(for configurationTitle: String) -> Interval {
        switch configurationTitle {
        case "Anaerobic Lactic Energy System (Glycolytic System)":
            return Interval(title: "Lifting Interval", options: ["30 seconds", "45 seconds", "1 minute", "1 minute 30 seconds"])
        case "Aerobic Energy System (Oxidative System)":
            return Interval(title: "Running Interval", options: ["1 minute", "2 minutes"])
        default:
            return Interval(title: "", options: [])
        }
    }
}
