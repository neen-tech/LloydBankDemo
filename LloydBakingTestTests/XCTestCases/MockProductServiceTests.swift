import XCTest
import Combine
@testable import LloydBakingTest

class MockProductServiceTests: XCTestCase {
    var mockService: MockProductService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockProductService()
        cancellables = []
    }
    
    override func tearDown() {
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchProducts_Success() {
        // Given
        // Given
        let expectedProducts = [
            Products(id: 1,
                     title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                     price: 109.95,
                     description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                     category: "men's clothing",
                     image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
                     rating: Rating(rate: 3.9,
                                    count: 120)
                    ),
            Products(id: 2,
                     title: "Mens Casual Premium Slim Fit T-Shirts ",
                     price: 22.3,
                     description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
                     category:  "men's clothing",
                     image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
                     rating: Rating(rate: 4.1,
                                    count: 259))
            
        ]
        mockService.testData = expectedProducts
        // When
        let expectation = XCTestExpectation(description: "Fetch products successfully")
        let testURL = URL(string: "https://mockapi.com/products")!
        mockService.fetchData(from: testURL)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { products in
                XCTAssertEqual(products, expectedProducts, "Products should match expected products")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchProducts_Failure() {
        // Given
        mockService.testError = NSError(domain: "TestError", code: -1, userInfo: nil)
        
        // When
        let expectation = XCTestExpectation(description: "Fetch products failure")
        let testURL = URL(string: "https://mockapi.com/products")!
        
        mockService.fetchData(from: testURL)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got value")
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
