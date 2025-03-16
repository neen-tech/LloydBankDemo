import Foundation
import Combine
@testable import LloydBakingTest

class MockProductsRepository: ProductsRepositoryProtocol {
    var mockProducts: [Products] = []
    var shouldReturnError = false
    
    func getProducts() -> AnyPublisher<[Products], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "TestError", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        } else {
            return Just(mockProducts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}




