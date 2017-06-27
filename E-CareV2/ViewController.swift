//
//  ViewController.swift
//  E-CareV2
//
//  Created by Nupur Sharma on 15/06/17.
//  Copyright © 2017 Franciscan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
         self.logoImage.alpha = 0
        
        UIView.animate(withDuration: 6, animations: {
            
        self.logoImage.alpha = 1
        self.logoImage.frame.size.width += 15
        self.logoImage.frame.size.height += 15
            
        }) { (bool) in
        self.performSegue(withIdentifier: "launch", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

