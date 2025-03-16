// MARK: - Product Model

typealias ProductsData = [Products]

struct Products: Codable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    // Conforming to Hashable by using the id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Rating Model
struct Rating: Codable, Hashable {
    let rate: Double
    let count: Int
}
