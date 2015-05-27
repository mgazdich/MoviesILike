//
//  MovieTrailerViewController.m
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/19/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "MovieTrailerViewController.h"

@interface MovieTrailerViewController ()

@end

@implementation MovieTrailerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = [self.movieData objectAtIndex:0];
    
    NSString *youTubeTrailerID = [self.movieData objectAtIndex:2];
    // The embed tag embeds the video player within the HTML page with its controls
    NSString *youTubeURL = [[NSString alloc] initWithFormat:@"http://www.youtube.com/embed/%@", youTubeTrailerID];
    
    // Ask the UIWebView object to display the web page at the You Tube URL
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:youTubeURL]]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Starting to load the web page. Show the animated activity indicator in the status bar
    // to indicate to the user that the UIWebVIew object is busy loading the web page.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Finished loading the web page. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Ignore this error if the page is instantly redirected via javascript or in another way
    if([error code] == NSURLErrorCancelled) return;
    
    // An error occurred during the web page load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Create the error message in HTML as a character string object pointed to by errorString
    NSString *errorString = [NSString stringWithFormat:
                             @"<html><font size=+2 color='red'><p>An error occurred: %@<br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>",
                             error.localizedDescription];
    
    // Display the error message within the UIWebView object
    [self.webview loadHTMLString:errorString baseURL:nil];
}

@end
