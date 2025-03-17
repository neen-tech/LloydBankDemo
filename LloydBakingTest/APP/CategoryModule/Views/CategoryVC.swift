import UIKit
import Foundation
import Combine

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableViewCategry: UITableView!
    
    var categoryVM : CategoryViewModel = CategoryViewModel()
    var dataSource: UITableViewDiffableDataSource<Int, String>!
    var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        categoryVM.getCategory()
        setupBindings()
        setupUI()
        
    }
    
    func setupUI() {
        self.categoryVM.$viewName
            .receive(on: DispatchQueue.main)
            .sink { name in
            self.title = name
        }
        .store(in: &cancellables)
        
        //MARK: - check internet availability
        checkInterNet()
    }
    
    // MARK: - Setup Data Source
     func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableViewCategry) { tableView, indexPath, category in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = category.capitalized
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        }
      
    }

    private func checkInterNet() {
        categoryVM.$internetCheck
            .receive(on: DispatchQueue.main)
            .sink { bool in
                if bool == false {
                    self.presentSimpleAlert(message: "Internet is not available. please try later!")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Bindings (Fetching from ViewModel)
    private func setupBindings() {
            AppLoader.shared.startLoading(view: self.view)
            categoryVM.$category
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.applySnapshot(category: categories)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Apply Snapshot to Diffable Data Source
    func applySnapshot(category: [String]) {
        guard dataSource != nil else {
            print("dataSource is nil! Make sure setupDataSource() is called before updating UI.")
            AppLoader.shared.stopLoading()
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(category)
        dataSource.apply(snapshot, animatingDifferences: true)
        AppLoader.shared.stopLoading()
    }
}

//MARK: - TableViewDelegate
extension CategoryVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCategory = dataSource.itemIdentifier(for: indexPath) else { return }
               print("Selected Category: \(selectedCategory)")
        
        let storyboard = UIStoryboard(name: StoryBoardName.Main, bundle: nil)
        let productsVC = storyboard.instantiateViewController(withIdentifier: StoryBoardID.productsVC) as! ProductsVC
        productsVC.vm = ProductsViewModel(categoryName: selectedCategory)
        self.navigationController?.pushViewController(productsVC, animated: true)
        // Deselect row after selection for better UX
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

