
import Foundation
import UIKit
import Combine

final class ProductsViewModel:ProductsViewModelProtocol {
    var error: String?
    @Published var internetCheck: Bool = true
    @Published var isCompleted: Bool
    @Published var products: ProductsData = []
    private var cancellables = Set<AnyCancellable>()
    var categoryName:String = "men's clothing"
    
    private let productsRepository: ProductsRepositoryProtocol
    //initialization of Product Repository 
    init(productsRepository: ProductsRepositoryProtocol = ProductRepository(), categoryName:String) {
        self.isCompleted = false
        self.productsRepository = productsRepository
        self.categoryName = categoryName
    }
    
    //MARK: - get all Products
    func getProducts() {
        
        if NetworkStatus.shared.isConnectedToNetwork() {
            productsRepository.getProducts()
                .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription  // Store error message
                case .finished:
                    self?.isCompleted = true
                    break
                }
            }
            receiveValue: { products in
                self.products = products.filter { $0.category.lowercased() == self.categoryName.lowercased() }
            }
            .store(in: &cancellables)
        } else {
            internetCheck = false
        }
    }
}
