//
//  EntryViewController.swift
//  MovieFinder
//
//  Created by Ashish Mishra on 4/19/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var appEntryImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.appEntryImage.alpha = self.appEntryImage.alpha + 0.5;
            
            }) { (BOOL finished) -> Void in
                self.appEntryImage.alpha = 1;
        }
    }
}
