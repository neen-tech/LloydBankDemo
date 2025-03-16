import XCTest
import Combine
@testable import LloydBakingTest

final class MockCategoryViewModelTests: XCTestCase {
    
    var mockRepository: MockCategoryRepository!
    var viewModel: MockCategoryViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCategoryRepository()
        viewModel = MockCategoryViewModel(categoryRepositoryProtocol: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_get_category_success_vm() {
        // Given
        let expectedCategories = ["electronics","jewelery","men's clothing","women's clothing"]
        mockRepository.mockCategory = expectedCategories
        mockRepository.shouldReturnError = false
        
        // When
        let expectation = self.expectation(description: "Categories fetched successfully")
        
        viewModel.$category
            .dropFirst()
            .sink { category in
                XCTAssertEqual(category, expectedCategories)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getCategory()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_category_failure_case_vm() {
        // Given
        mockRepository.shouldReturnError = true
        
        // When
        let expectation = self.expectation(description: "Categories fetch failed")
        
        viewModel.$error
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                XCTAssertFalse(self.viewModel.isCompleted)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getCategory()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
