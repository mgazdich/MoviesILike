//
//  MoviesViewController.h
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/14/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMovieViewController.h"
#import "MovieTrailerViewController.h"
#import "AppDelegate.h"

@class AppDelegate;

@interface MoviesViewController : UITableViewController <AddMovieViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;

@end
