import Foundation

protocol TimerConfigurationPresenterProtocol: ObservableObject {
    var configurations: [Configuration] { get }
    var currentPage: Int { get set }
    var totalPages: Int { get }
    func getCurrentConfiguration() -> Configuration
}

class TimerConfigurationPresenter: TimerConfigurationPresenterProtocol {
    @Published var configurations: [Configuration] = []
    @Published var currentPage: Int = 1
    
    private let interactor: TimerConfigurationInteractorProtocol
    
    var totalPages: Int {
        configurations.count
    }
    
    init(interactor: TimerConfigurationInteractorProtocol) {
        self.interactor = interactor
        self.configurations = interactor.fetchConfigurations()
    }
    
    func getCurrentConfiguration() -> Configuration {
        return configurations[currentPage - 1]
    }
}
