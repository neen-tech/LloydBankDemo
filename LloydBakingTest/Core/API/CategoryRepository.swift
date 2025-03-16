import Foundation
import Combine

// MARK: - Repository Protocols
protocol CategoryRepositoryProtocol {
    func getCategory() -> AnyPublisher<Category, Error>
}


// MARK: - Repositories
class CategoryRepository: CategoryRepositoryProtocol {
   
    private let networkService: NetworkService<Category>
    private let url = URL(string: BaseUrl.URL + Path.categories)!
    
    init(networkService: NetworkService<Category> = NetworkService<Category>()) {
        self.networkService = networkService
    }
    
    func getCategory() -> AnyPublisher<Category, Error> {
        networkService.fetchData(from: url)
    }
    
}
