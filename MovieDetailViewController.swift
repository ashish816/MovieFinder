//
//  MovieDetailViewController.swift
//  MovieFinder
//
//  Created by Ashish Mishra on 4/17/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var movieOverview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieOverview.editable = false;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func showOverview(movieData : MovieDetail) {
        NSLog(movieData.movieOverView!);
        NSLog("\(movieOverview)");
        NSLog(self.movieOverview.text!);

        self.movieOverview.text = movieData.movieOverView;
    }
    
    @IBAction func disableModalViewController(sendor: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        };
    }

}
