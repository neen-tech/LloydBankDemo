import UIKit
import Combine
import SDWebImage

class ProductsVC: UIViewController {
    
    var vm:ProductsViewModel = ProductsViewModel(categoryName: "men's clothing")
    @IBOutlet weak var tableViewProducts: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Int, Products>!
    var cancellables = Set<AnyCancellable>()
    var cancellable : AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial UI component setup
        setupUI()
        checkInterNet()
        // Fetching Data from API
    }
    //MARK: - setup data sources
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Products>(tableView: tableViewProducts) { tableView, indexPath, product in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.productCell, for: indexPath) as? ProductCell else {
                return UITableViewCell()
            }
            cell.title.text = product.title
            if let url = URL(string: product.image) {
                // Load image asynchronously using an image loading library
                cell.imageProducts.sd_setImage(with: url)
            }
            cell.ratings.text = " \(product.rating.rate) rate \(product.rating.count) views"
            cell.desc.text = product.description
            cell.price.text = "$\(product.price)"
            return cell
        }
    }
    
    func checkInterNet() {
        vm.$internetCheck
            .receive(on: DispatchQueue.main)
            .sink { bool in
                if bool == false {
                    self.presentSimpleAlert(message: "Internet is not available. please try later!")
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Binding or get products from View Models
    private func setupBindings() {
        AppLoader.shared.startLoading(view: self.view)
        vm.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.applySnapshot(products: products)
            }
            .store(in: &cancellables)
    }
    //MARK: - apply screenshot or adding data into NSDiffableDataSourceSnapshot
    private func applySnapshot(products: [Products]) {
        guard dataSource != nil else {
            print("dataSource is nil! Make sure setupDataSource() is called.")
            AppLoader.shared.stopLoading()
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Products>()
        snapshot.appendSections([0])
        snapshot.appendItems(products)
        self.dataSource.apply(snapshot, animatingDifferences: false)
        AppLoader.shared.stopLoading()
    }
    // Setup UI conponents on view
    func setupUI() {
        //set Navigation Title
        self.title = "Products"
        // Registing the table View Cell
        tableViewProducts.register(UINib(nibName: CellIdentifiers.productCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.productCell)
        // setup table delegate
        // View Model Object
        setupDataSource()
        vm.getProducts()
        setupBindings()
    }
    
}

//MARK: - Delegate
extension ProductsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = dataSource.itemIdentifier(for: indexPath) else { return }
        print("Selected Product: \(product.title)")
        
        // Navigate to a detail screen
    }
}

