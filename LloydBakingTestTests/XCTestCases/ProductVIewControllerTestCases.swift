import XCTest
import Combine
@testable import LloydBakingTest


class ProductsVCTests: XCTestCase {
    var sut: ProductsVC!
    var viewModel: MockViewModelProducts!
    var mockRepository: MockProductsRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = ProductsVC()
        mockRepository = MockProductsRepository()
        viewModel = MockViewModelProducts(productsRepository: mockRepository)
        cancellables = []
        // Load ViewController from Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "ProductsVC") as? ProductsVC
        //sut.vm = viewModel  // Inject Mock ViewModel
        sut.loadViewIfNeeded()  // Ensures UI elements are loaded
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testViewDidLoad_InitialSetup() {
        XCTAssertNotNil(sut.tableViewProducts, "TableView should be connected")
        XCTAssertEqual(sut.title, "Products", "Title should be set to Products")
    }
    
    func testSetupBindings_UpdatesDataSource() {
        // Given
        let localJsonData = loadLocalTestData(from: "TestData", for: ProductsVCTests.self)
        let decoder = JSONDecoder()
        // Decode JSON into `productsResponse`
        guard let expectedProducts = try? decoder.decode([Products].self, from: localJsonData) else {
            XCTFail("Failed to decode mock cat data.")
            return
        }
        
        let expectation = XCTestExpectation(description: "Binding updates tableView dataSource")
        // When
        sut.vm.products = expectedProducts
        sut.vm.$products
            .dropFirst()
            .sink { products in
                XCTAssertEqual(products.first?.title, expectedProducts.first?.title, "Products should match expected data")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}

