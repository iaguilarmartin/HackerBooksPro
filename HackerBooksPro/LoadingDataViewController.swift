import UIKit

// View Controller to display a loading screen while JSON data is being processed
class LoadingDataViewController: UIViewController {
    
    var rootViewController: UIViewController?
    
    //MARK: - Initializers
    init(nextViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        rootViewController = nextViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func presentRootViewController() {
        self.present(rootViewController!, animated: true, completion: nil)
    }
}
