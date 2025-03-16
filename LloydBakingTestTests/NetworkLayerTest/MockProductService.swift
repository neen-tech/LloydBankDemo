import Foundation
import Combine
@testable import LloydBakingTest

class MockProductService: APIService {
    var testData: [Products]?
    var testError: Error?
    //MARK: - fetch product using mock API
    
    func fetchData(from url: URL) -> AnyPublisher<ProductsData, Error> {
        if let error = testError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let testData = testData {
            return Just(testData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}
