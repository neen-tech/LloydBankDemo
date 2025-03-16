import XCTest
import Combine
@testable import LloydBakingTest

class MockProductsRepositoryTests: XCTestCase {
    var mockRepository: MockProductsRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockProductsRepository()
        cancellables = []
    }
    
    override func tearDown() {
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_get_products_success_test_case() {
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
        mockRepository.mockProducts = expectedProducts
        mockRepository.shouldReturnError = false
        
        // When
        let expectation = XCTestExpectation(description: "Fetch products successfully")
        
        mockRepository.getProducts()
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
    
    
    func test_get_products_failure_case() {
        // Given
        mockRepository.shouldReturnError = true
        
        // When
        let expectation = XCTestExpectation(description: "Fetch products failure")
        
        mockRepository.getProducts()
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

