//
//  ViewController.swift
//  MovieFinder
//
//  Created by Ashish Mishra on 4/13/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MoviesDataConnectionControllerDelegate {

    @IBOutlet weak var searchResultsTableView: UITableView!
    var movieDetail : MovieDetail?
    var searchResultsData: NSArray = []
    var resultsController: MoviesDataConnectionController = MoviesDataConnectionController()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMovies()
        // Do any additional setup after loading the view, typically from a nib.
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
        let imgData: NSData = resultsController.retreiveImageData(posterPath)
        cell.imageView!.image = UIImage(data: imgData)
        }
        
        let releaseDate: String = cellData.relaseDate!
        cell.detailTextLabel!.text = releaseDate
        
        return cell
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
                
                if((self.movieDetail) != nil){
                destination.showOverview(self.movieDetail!)
                }
            }
        }
    }
  
}

