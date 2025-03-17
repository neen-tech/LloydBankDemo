
import Foundation
import Combine



protocol CategoryViewModelProtocol {
    var error: String? { get }
    func getCategory()
    var category: Category { get }
    var isCompleted: Bool { get }
    var internetCheck: Bool { get }
}

final class CategoryViewModel: CategoryViewModelProtocol {
    @Published var category = Category()
    var isCompleted: Bool = false
    @Published var internetCheck: Bool =  true
    var error : String?
    @Published var viewName : String = "Category"
    private var cancellables = Set<AnyCancellable>()
    private let categoryRepositoryProtocol: CategoryRepositoryProtocol
    init( categoryRepositoryProtocol: CategoryRepositoryProtocol = CategoryRepository()) {
        self.categoryRepositoryProtocol = categoryRepositoryProtocol
    }
    
    //Get Category
    func getCategory() {
        if !NetworkStatus.shared.isConnectedToNetwork() {
            internetCheck = false
            return
        }
        self.categoryRepositoryProtocol.getCategory()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.isCompleted = true
            case .failure(let error):
                self.isCompleted = false
                self.error = error.localizedDescription
            }
        }, receiveValue: { [weak self] category in
            self?.category = category
        })
        .store(in: &cancellables)
    }
    
}
