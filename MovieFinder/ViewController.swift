//
//  ViewController.swift
//  MovieFinder
//
//  Created by Ashish Mishra on 4/13/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MoviesDataConnectionControllerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    var movieDetail : MovieDetail?
    var searchResultsData: NSArray = []
    var resultsController: MoviesDataConnectionController = MoviesDataConnectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
              return searchResultsData.count;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var rotation : CATransform3D = CATransform3DMakeRotation(CGFloat(90.0*M_PI)/180 , 0.0, 0.7, 0.4)
        rotation.m34 = (1.0/600);
        cell.layer.shadowColor = UIColor.blackColor().CGColor;
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        UIView.beginAnimations("rotation", context: nil);
        UIView.setAnimationDuration(0.8);
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        UIView.commitAnimations()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "MovieResultCell"
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        
        let cellData: MovieDetail = self.searchResultsData[indexPath.row] as! MovieDetail
        cell.textLabel!.text = cellData.movieTitle!
        
        if let posterPath = cellData.posterPath {
            self.retreiveImageData(posterPath,indexPath: indexPath)
        } else {
            
            let bundlePath = NSBundle.mainBundle().pathForResource("download", ofType: "png")
            cell.imageView!.image = UIImage(contentsOfFile: bundlePath!)
            cell.setNeedsLayout()
        }
        
        let releaseDate: String = cellData.relaseDate!
        cell.detailTextLabel!.text = releaseDate
        
        return cell
    }
    
    func retreiveImageData(posterPath : String?, indexPath: NSIndexPath) {
        guard let posterPath = posterPath else {
            return
        }
        let baseUrl: String = "http://image.tmdb.org/t/p/w300"
        let urlString: String = "\(baseUrl)" + "\(posterPath)"
        let imgURL: NSURL = NSURL(string: urlString)!
        
        NSURLSession.sharedSession().dataTaskWithURL(imgURL) { (data, response, erro) -> Void in
            guard let data = data else {
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let cell : UITableViewCell = self.searchResultsTableView.cellForRowAtIndexPath(indexPath) {
                cell.imageView!.image = UIImage(data: data)
                cell.setNeedsLayout()
                }
            })
            }.resume()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.movieDetail = self.searchResultsData[indexPath.row] as? MovieDetail
        if let _ = tableView.cellForRowAtIndexPath(indexPath){
            self.performSegueWithIdentifier("moviedetail", sender: self);
        }
    }
    
    func searchMovies(serachedString : String)
    {
        
        self.resultsController.delegate = self
        resultsController.retreiveSearchResults(serachedString)
    }
    
    func requestFailedWithError(error: String) {
        let alertController = UIAlertController(title: "Error", message:
            error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func requestSucceedWithResults(results: NSArray) {
        self.searchResultsData = results
        self.searchResultsTableView.reloadData()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moviedetail" {
            if let destination = segue.destinationViewController as? MovieDetailViewController{
                destination.movieDetail = self.movieDetail;
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            let mutableSearchResults : NSMutableArray = self.searchResultsData.mutableCopy() as! NSMutableArray;
            mutableSearchResults.removeAllObjects()
            let searchedResults : NSArray = mutableSearchResults.copy() as! NSArray
            self.searchResultsData = searchedResults
            self.searchResultsTableView.reloadData()
        }
        self.searchMovies(searchText);
    }
    

}

