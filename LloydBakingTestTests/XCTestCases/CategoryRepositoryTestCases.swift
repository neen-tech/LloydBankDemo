import XCTest
import Combine
@testable import LloydBakingTest



class MockCategoryRepositoryTests: XCTestCase {
    var mockRepository: MockCategoryRepository!
    var cancellables: Set<AnyCancellable>!
    override func setUp() {
        super.setUp()
        mockRepository = MockCategoryRepository()
        cancellables = []
    }
    
    override func tearDown() {
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_get_category_success_test_case() {
        // Given
        let expectedCategories = ["electronics","jewelery","men's clothing","women's clothing"]
        mockRepository.mockCategory = expectedCategories
        mockRepository.shouldReturnError = false
        
        // When
        let expectation = self.expectation(description: "Categories fetched successfully")
        
        mockRepository.getCategory()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { categories in
                // Then
                XCTAssertEqual(categories, expectedCategories)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_category_failure_test_case() {
        // Given
        mockRepository.shouldReturnError = true
        // When
        let expectation = self.expectation(description: "Categories fetch failed")
        mockRepository.getCategory()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    } 
}
