import SwiftUI

@main
struct BoxingProTrainerApp: App {
    var body: some Scene {
        WindowGroup {
            // Create the Interactor
            let interactor = TimerConfigurationInteractor()
            
            // Create the Presenter with the Interactor
            let presenter = TimerConfigurationPresenter(interactor: interactor)
            
            // Pass the Presenter to the TimerConfigurationView
            TimerConfigurationView(presenter: presenter)
        }
    }
}
