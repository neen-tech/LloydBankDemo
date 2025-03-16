struct BaseUrl {
    static let URL = "https://fakestoreapi.com"
}

struct Path {
    static let products = "/products"
    static let categories = "/products/categories"
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}


