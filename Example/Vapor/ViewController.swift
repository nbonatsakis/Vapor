//
//  ViewController.swift
//  Vapor
//
//  Created by Nicholas Bonatsakis on 11/28/2016.
//  Copyright (c) 2016 Nicholas Bonatsakis. All rights reserved.
//

import UIKit
import Vapor
import Anchorage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.show(emptyState: self.emptyState)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
            self.hide(emptyState: self.emptyState)
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: VaporDataSource {

    var numberOfItems: Int {
        return 0
    }

    var emptyState: EmptyState {
        let action = EmptyStateAction(title: "Some Action") {}
        return EmptyState(message: "Some great message about how awesome this component is!", image: #imageLiteral(resourceName: "bookmarks"), action: action)
    }

    var viewForEmptyState: UIView {
        return self.view
    }
    
}
