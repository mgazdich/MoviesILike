//
//  AddMovieViewController.m
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/19/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "AddMovieViewController.h"

@interface AddMovieViewController ()

@end

@implementation AddMovieViewController

- (void)viewDidLoad
{
    // Instantiate a Save button to invoke the save: method when tapped
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(save:)];
    
    // Set up the Save custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = saveButton;
}


- (IBAction)keyboardDone:(id)sender
{
    [sender resignFirstResponder];  // Deactivate the keyboard
}


- (void)save:(id)sender
{
    if ([self.movieName.text isEqualToString:@""] || [self.topStars.text isEqualToString:@""] || [self.primGenre.text isEqualToString:@""] || [self.youTubeID.text isEqualToString:@""]){
        // Create the Alert View
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill all textboxes"
                                                        message:@"No text is entered in any of the two text fields"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        // Inform the delegate that the user tapped the Save button
        [self.delegate addMovieViewController:self didFinishWithSave:YES];
    }
}

@end
