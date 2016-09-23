//
//  LoadingDataViewController.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 22/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class LoadingDataViewController: UIViewController {
    
    var rootViewController: UIViewController?
    
    init(nextViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        rootViewController = nextViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentRootViewController() {
        self.present(rootViewController!, animated: true, completion: nil)
    }
}
