//
//  MoviesViewController.swift
//  RottenTomatoesClient
//
//  Created by Kevin Raymundo on 8/28/15.
//  Copyright (c) 2015 100kV. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var networkErrorView: UIView!
    
    let boxOffice = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
    
    let topDvds = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
    
    var movies: NSArray!
    
    var refreshControl: UIRefreshControl!
    
    let DELAY_SECONDS: Double = 1;
    
    let NETWORK_ERROR_VIEW_HEIGHT: CGFloat = 52
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("awesome.MovieViewCell", forIndexPath: indexPath) as! MovieViewCell
        var movie = movies![indexPath.row] as! NSDictionary
        
        var url = movie.valueForKeyPath("posters.detailed") as! String
        
        cell.posterActivityIndicatorView.startAnimating()
        cell.posterImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: url)!), placeholderImage: nil, success: { (NSURLRequest, NSHTTPURLResponse, UIImage) -> Void in
                self.delay(self.DELAY_SECONDS, closure: {
                    cell.posterActivityIndicatorView.stopAnimating()
                    cell.posterImageView.alpha = 0.0
                    cell.posterImageView.image = UIImage
                    UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        cell.posterImageView.alpha = 1.0
                        }, completion: nil)
                })
            }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
                cell.posterActivityIndicatorView.stopAnimating()
                self.showError()
        }
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        return cell
    }
    
    func hideError() {
        networkErrorView.frame.size.height = 0 as CGFloat
        networkErrorView.hidden = true
    }
    
    func showError() {
        networkErrorView.frame.size.height = NETWORK_ERROR_VIEW_HEIGHT
        networkErrorView.hidden = false
        delay(DELAY_SECONDS, closure: {
            self.hideError()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        hideError()
        var url = NSURL(string: boxOffice)
        var request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            self.delay(self.DELAY_SECONDS, closure: {
                self.refreshControl.endRefreshing()
                
                if let error = error {
                    self.showError()
                } else {
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    if let json = json {
                        let newMovies = json["movies"] as! NSArray
                        if (newMovies != self.movies) {
                            self.movies = json["movies"] as! NSArray
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideError()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableActivityIndicatorView.startAnimating()
        tableActivityIndicatorView.hidesWhenStopped = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        var url = NSURL(string: boxOffice)
        var request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            self.delay(self.DELAY_SECONDS, closure: {
                self.tableActivityIndicatorView.stopAnimating()
                
                if let error = error {
                    self.showError()
                } else {
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    if let json = json {
                        let newMovies = json["movies"] as! NSArray
                        if (newMovies != self.movies) {
                            self.movies = json["movies"] as! NSArray
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row] as! NSDictionary
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
















