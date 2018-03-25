//
//  ArtistViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 25/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {
    @IBOutlet weak private var photo: UIImageView!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var profile: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }


}
