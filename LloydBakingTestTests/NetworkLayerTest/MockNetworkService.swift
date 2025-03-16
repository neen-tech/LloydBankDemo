import Foundation
import Combine
@testable import LloydBakingTest

// MARK: - Mock Network Service
class MockNetworkService<T: Codable>: APIService {
    var testResponseData: Data?
    var testError: Error?
    
    func fetchData(from url: URL) -> AnyPublisher<T, Error> {
        if let error = testError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        guard let data = testResponseData else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return Just(decodedData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

