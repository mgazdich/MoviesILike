//
//  AddMovieViewController.h
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/19/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddMovieViewControllerDelegate;


@interface AddMovieViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *movieName;
@property (strong, nonatomic) IBOutlet UITextField *topStars;
@property (strong, nonatomic) IBOutlet UITextField *primGenre;
@property (strong, nonatomic) IBOutlet UITextField *youTubeID;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ratingSegView;

@property (nonatomic, assign) id <AddMovieViewControllerDelegate> delegate;

// The keyboardDone: method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender;
@end

/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol AddMovieViewControllerDelegate

- (void)addMovieViewController:(AddMovieViewController *)controller didFinishWithSave:(BOOL)save;

@end
