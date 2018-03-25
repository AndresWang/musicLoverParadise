//
//  ArtistViewController.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 25/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {

    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var lable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lable.text = "Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view."
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(scroller.subviews[0].bounds.size)
        scroller.contentSize = CGSize(width: 320, height: 1000)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
