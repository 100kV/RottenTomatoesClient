//
//  MovieDetailsViewController.swift
//  RottenTomatoesClient
//
//  Created by Kevin Raymundo on 8/29/15.
//  Copyright (c) 2015 100kV. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var titleSynopsisView: UIView!
    
    var movie: NSDictionary!
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.detailed") as! String
        var range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        titleSynopsisView.hidden = true
        posterActivityIndicatorView.startAnimating()
        posterActivityIndicatorView.hidesWhenStopped = true
        
        posterImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: url)!), placeholderImage: nil, success: { (NSURLRequest, NSHTTPURLResponse, UIImage) -> Void in
            self.delay(1, closure: {
                self.posterActivityIndicatorView.stopAnimating()
                self.posterImageView.image = UIImage
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = UIImage
                UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.posterImageView.alpha = 1.0
                    }, completion: nil)
                self.titleSynopsisView.hidden = false
            })
        }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
            self.posterActivityIndicatorView.stopAnimating()
            // Show error
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
