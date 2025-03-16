import XCTest
import Combine
@testable import LloydBakingTest

// MARK: - Unit Test
class NetworkServiceMockTests: XCTestCase {
    var mockService : MockNetworkService<ProductsData>!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService<ProductsData>()
    }
    
    override func tearDown() {
        mockService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    //MARK: - Unit Test case for fetching products success
    func testFetchProductsSuccess() {
        let localJsonData = loadLocalTestData(from: "TestData", for: NetworkServiceMockTests.self)
        // Decode JSON into `UserResponse`
        mockService.testResponseData = localJsonData
        let expectation = XCTestExpectation(description: "Fetch products successfully")
        let url = URL(string: "https://mockurl.com/products")!
        mockService.fetchData(from: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, got error: \(error)")
                }
            }, receiveValue: { products in
                XCTAssertEqual(products.count, 2, "Expected 2 product to there.")
                XCTAssertEqual(products.first?.title, "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 8.0)
    }
    
    // MARK: - Unit Test Failure Case
    func testFetchProductsFailure() {
        mockService.testError = URLError(.notConnectedToInternet)
        let expectation = XCTestExpectation(description: "Fetch products failure")
        let url = URL(string: "https://mockurl.com/products")!
        mockService.fetchData(from: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Expected failure, but got nil error")
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received products")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }

}
