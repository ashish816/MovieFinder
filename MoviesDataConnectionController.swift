//
//  MoviesDataConnectionController.swift
//  MovieFinder
//
//  Created by Ashish Mishra on 4/13/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

protocol MoviesDataConnectionControllerDelegate {
    func requestSucceedWithResults(results: NSArray)
    func requestFailedWithError(error: String)
}

class MoviesDataConnectionController: NSObject {
    var delegate: MoviesDataConnectionControllerDelegate?;
    
    override init() {
        
    }
    
    func retreiveImageData(posterPath : String?)->NSData {
        guard let posterPath = posterPath,
            let baseUrl: String = "http://image.tmdb.org/t/p/w300",
            let urlString: String = "\(baseUrl)" + "\(posterPath)",
            let imgURL: NSURL = NSURL(string: urlString)
            else {
                let defaultImageUrl: NSURL = NSURL(string: "https://assets.tmdb.org/images/logosvar_8_0_tmdb-logo-2_Bree.png")!
                    return  NSData(contentsOfURL: defaultImageUrl)!
            }
           return  NSData(contentsOfURL: imgURL)!
    }
    
    func retreiveSearchResults(var queryKeyword : String)
    {
        let APIkey: String = "34747ce9a4b8fd531c6818fe2b2b3155" //Replace with your Api Key"
        let APIBaseUrl: String = "https://api.themoviedb.org/3/search/movie?api_key="
        queryKeyword = "titanic";
        let urlString:String = "\(APIBaseUrl)" + "\(APIkey)"+"&"+"query=" + "\(queryKeyword)";

        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!);
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data , response, error) -> Void in
            guard let data = data else {
                self.delegate?.requestFailedWithError(error.debugDescription)
                return
            }
            self.generateResults(data);
        }.resume()
    }
    
    func generateResults(requestData : NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(requestData, options: .AllowFragments)
            guard let jsonDictionary: NSDictionary = jsonResult as? NSDictionary else
            {
                self.delegate?.requestFailedWithError("ERROR: conversion from JSON failed")
                return
            }
            let results: NSArray = jsonDictionary["results"] as! NSArray
            
            let searchedMovies : NSMutableArray = NSMutableArray();
            for  Obj in results {
                let movieDetail = MovieDetail();
                let movieInfo = Obj as? NSDictionary;
                movieDetail.movieTitle = movieInfo!["title"] as? String;
                movieDetail.relaseDate = movieInfo!["release_date"] as? String;
                movieDetail.posterPath = movieInfo!["poster_path"] as? String;
                searchedMovies.addObject(movieDetail);
            }
            self.delegate?.requestSucceedWithResults(searchedMovies.copy() as! NSArray)
            }
            catch {
                self.delegate?.requestFailedWithError("ERROR: conversion from JSON failed")
            }
    }
}
