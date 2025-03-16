import Foundation
import Combine
@testable import LloydBakingTest

class MockCategoryRepository: CategoryRepositoryProtocol {
    
    var mockCategory:[String] = []
    var shouldReturnError:Bool = false
    
    func getCategory() -> AnyPublisher<[String], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "TestError", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        } else {
            return Just(mockCategory) // Use the correct mock variable
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
