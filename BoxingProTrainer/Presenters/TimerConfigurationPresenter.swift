import Foundation

protocol TimerConfigurationPresenterProtocol: ObservableObject {
    var configurations: [Configuration] { get }
    var currentPage: Int { get set }
    var totalPages: Int { get }
    var currentInterval: Interval { get }
    func getCurrentConfiguration() -> Configuration
    func updateInterval()
}

class TimerConfigurationPresenter: TimerConfigurationPresenterProtocol {
    @Published var configurations: [Configuration] = []
    @Published var currentPage: Int = 1
    @Published var currentInterval: Interval = Interval(title: "", options: [])

    private let interactor: TimerConfigurationInteractorProtocol
    
    var totalPages: Int {
        configurations.count
    }
    
    init(interactor: TimerConfigurationInteractorProtocol) {
        self.interactor = interactor
        self.configurations = interactor.fetchConfigurations()
        updateInterval()
    }
    
    func getCurrentConfiguration() -> Configuration {
        return configurations[currentPage - 1]
    }

    func updateInterval() {
        let configurationTitle = getCurrentConfiguration().title
        currentInterval = interactor.fetchIntervals(for: configurationTitle)
    }
}
