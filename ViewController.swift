//
//  ViewController.swift
//  MovieFinder
//
//  Created by Ashish Mishra on 4/13/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MoviesDataConnectionControllerDelegate,UISearchBarDelegate {

    @IBOutlet weak var searchResultsTableView: UITableView!
    var movieDetail : MovieDetail?
    var searchResultsData: NSArray = []
    var resultsController: MoviesDataConnectionController = MoviesDataConnectionController()
    
    
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMovies()
    }

    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
              return searchResultsData.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "MovieResultCell"
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        
        let cellData: MovieDetail = self.searchResultsData[indexPath.row] as! MovieDetail
        cell.textLabel!.text = cellData.movieTitle!
        
        if let posterPath = cellData.posterPath {
        self.retreiveImageData(posterPath,indexPath: indexPath)
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
    
    func searchMovies()
    {
      
        self.resultsController.delegate = self
        resultsController.retreiveSearchResults("")
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableView.reloadData()
//    }  
}

