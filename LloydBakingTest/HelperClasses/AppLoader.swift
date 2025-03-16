
import UIKit

class AppLoader {
    static let shared = AppLoader()
    var spinner = UIActivityIndicatorView(style: .large)
    var interactView = UIView()
    private init() { }
    
    func startLoading(view:UIView) {
        self.spinner.center = view.center
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.interactView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: view.frame.size.width,
                                         height: view.frame.size.height)
        view.addSubview(self.interactView)
        view.addSubview( self.spinner)
        self.spinner.color = .black
        self.spinner.centerXAnchor.constraint(equalTo: self.interactView.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: self.interactView.centerYAnchor).isActive = true
        self.spinner.startAnimating()
    }
    
    func stopLoading() {
        self.spinner.removeFromSuperview()
        self.interactView.removeFromSuperview()
        self.spinner.stopAnimating()
    }
}
