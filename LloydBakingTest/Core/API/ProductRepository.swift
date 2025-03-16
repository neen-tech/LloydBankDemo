import Foundation
import Combine

// MARK: - Repository Protocols
protocol ProductsRepositoryProtocol {
    func getProducts() -> AnyPublisher<ProductsData, Error>
}


// MARK: - Repositories
class ProductRepository: ProductsRepositoryProtocol {
    private let networkService: NetworkService<ProductsData>
    private let url = URL(string: BaseUrl.URL + Path.products)!
    
    init(networkService: NetworkService<ProductsData> = NetworkService<ProductsData>()) {
        self.networkService = networkService
    }
    
    func getProducts() -> AnyPublisher<ProductsData, Error> {
        networkService.fetchData(from: url)
    }
}
