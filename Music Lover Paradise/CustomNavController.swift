//
//  CustomNavController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 25/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ArtistViewController {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        } else {
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
        }
    }
}
