
import Foundation
import Combine


protocol APIService {
    associatedtype Model : Codable
    func fetchData(from url: URL) -> AnyPublisher<Model, Error>
}
// MARK: - Generic Network Service
class NetworkService<T: Codable>: APIService {
  //  typealias Model = T
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(from url: URL) -> AnyPublisher<T, Error> {
        self.session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
//    func fetchCategoryProducts(from url: URL) -> AnyPublisher<T, Error> {
//        self.session.dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: T.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
}

