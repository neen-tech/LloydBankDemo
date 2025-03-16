import XCTest
import Combine
@testable import LloydBakingTest

final class MockCategoryViewModel:CategoryViewModelProtocol {
    @Published var category = Category()
    var isCompleted: Bool = false
    @Published var error : String?
    private var cancellables = Set<AnyCancellable>()
    private let categoryRepositoryProtocol: CategoryRepositoryProtocol
    init( categoryRepositoryProtocol: CategoryRepositoryProtocol = CategoryRepository()) {
        self.categoryRepositoryProtocol = categoryRepositoryProtocol
    }

    //MARK: - get all Products
    func getCategory() {
        self.categoryRepositoryProtocol.getCategory()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isCompleted = false
            switch completion {
            case .failure(let error):
                self?.error = error.localizedDescription  // Store error message
            case .finished:
                self?.isCompleted = true
                break
            }
        } receiveValue: { category in
            self.category = category
        }
        .store(in: &cancellables)
    }
}

