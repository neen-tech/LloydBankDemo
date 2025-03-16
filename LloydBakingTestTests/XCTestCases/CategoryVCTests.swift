import XCTest
import Combine
@testable import LloydBakingTest

class CategoryVCTests: XCTestCase {
    
    var viewController: CategoryVC!
    var mockViewModel: CategoryViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockViewModel = CategoryViewModel(categoryRepositoryProtocol: MockCategoryRepository())
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC
        viewController.loadViewIfNeeded()
        viewController.categoryVM = mockViewModel
        cancellables = []
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testViewDidLoad_CallsGetCategory() {
        // Given
        let expectation = self.expectation(description: "Fetch categories")
        mockViewModel.$category
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewController.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
    
    func testApplySnapshot_UpdatesTableView() {
        // Given
        let categories = ["electronics","jewelery","men's clothing","women's clothing"]
        
        // When
        viewController.applySnapshot(category: categories)
        
        // Then
        let snapshot = viewController.dataSource.snapshot()
        XCTAssertEqual(snapshot.numberOfItems, categories.count)
        XCTAssertEqual(snapshot.itemIdentifiers, categories)
    }
    
    func testDidSelectRow_PushesProductVC() {
        // Given
        let categories = ["electronics","jewelery","men's clothing","women's clothing"]
        viewController.applySnapshot(category: categories)
        let indexPath = IndexPath(row: 0, section: 0)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        // When
        viewController.tableView(viewController.tableViewCategry, didSelectRowAt: indexPath)
        
        // Then
        XCTAssertTrue(navigationController.topViewController is ProductsVC)
    }
}
