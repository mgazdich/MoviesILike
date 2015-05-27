//
//  MovieTrailerViewController.h
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/19/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTrailerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@property (strong, nonatomic) NSArray *movieData;

@end
