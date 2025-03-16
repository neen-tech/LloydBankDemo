import Foundation

// View Model protocol
protocol ProductsViewModelProtocol {
    var error: String? { get }
    func getProducts()
    var products: ProductsData { get }
    var isCompleted: Bool { get }
}
