
import XCTest
import Combine
@testable import LloydBakingTest


final class MockViewModelProducts:ProductsViewModelProtocol {
    var error: String?
    var isCompleted: Bool
    @Published var products: [Products] = []
    private var cancellables = Set<AnyCancellable>()
    private let productsRepository: ProductsRepositoryProtocol
    //initialization of Product Repository
    init(productsRepository: ProductsRepositoryProtocol = ProductRepository()) {
        self.isCompleted = false
        self.productsRepository = productsRepository
    }
    
    //MARK: - get all Products
    func getProducts() {
        productsRepository.getProducts()
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
        } receiveValue: { products in
            self.products = products
        }
        .store(in: &cancellables)
    }
}


