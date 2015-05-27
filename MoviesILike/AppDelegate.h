//
//  AppDelegate.h
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/12/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Global Data countryCities is used by classes in this project
@property (strong, nonatomic) NSMutableDictionary *movieGenres;

@property (strong, nonatomic) NSMutableDictionary *theaterNamesDict;
//@property (strong, nonatomic) NSMutableArray *theaterNames;
@end
