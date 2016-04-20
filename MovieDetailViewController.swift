//
//  MovieDetailViewController.swift
//  MovieFinder
//
//  Created by Ashish Mishra on 4/17/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieDetail : MovieDetail!;
    @IBOutlet weak var youTubeVideo: UIWebView!
    @IBOutlet var movieOverview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieOverview.editable = false;
        self.movieOverview.text = self.movieDetail.movieOverView;
        self.retreiveVideoId()
    }
    
    func retreiveVideoId() {
        
        let APIkey: String = "34747ce9a4b8fd531c6818fe2b2b3155" //Replace with your Api Key"
        NSLog("\(self.movieDetail)");
        NSLog("\(self.movieDetail.movieId)");
        let APIBaseUrl: String = "https://api.themoviedb.org/3/movie/"+"\(self.movieDetail.movieId!)"+"/videos?api_key="
        let urlString:String = "\(APIBaseUrl)" + "\(APIkey)";
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!);
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data , response, error) -> Void in
            guard let data = data else {
                NSLog("Failure");
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showVideo(data);
            })
            }.resume()
        
    }
    
    func showVideo(data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            guard let jsonDictionary: NSDictionary = jsonResult as? NSDictionary else
            {
                NSLog("Conversion from JSON failed");
                return
            }
            let results: NSArray = jsonDictionary["results"] as! NSArray
            if results.count > 0 {
            if let videoInfo = results[0] as? NSDictionary {
                let youTubeVideoId = videoInfo["id"] as! String;
                self.playVideo(youTubeVideoId);
            }
            }
        }
        catch {
            NSLog("Conversion from JSON failed");
        }
    }
    
    func playVideo(videoId : String){
        youTubeVideo.allowsInlineMediaPlayback = true
        let youTubelink: String = "http://www.youtube.com/embed/\(videoId)"
//        let youTubelink: String = "http://www.youtube.com/embed/GLPJSmUHZvU"

        let width = self.youTubeVideo.bounds.width;
        let height = self.youTubeVideo.bounds.height;
        let frame = 10;
        
        
        let Code:String = "<iframe width =\(width) height = \(height) src = \(youTubelink) frameborder = \(frame)></iframe>";
        self.youTubeVideo.loadHTMLString(Code as String, baseURL: nil);
    }
    
    
    @IBAction func disableModalViewController(sendor: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        };
    }

}
