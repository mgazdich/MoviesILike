//
//  AddTheaterViewController.m
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/22/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "AddTheaterViewController.h"

@interface AddTheaterViewController ()


@end

@implementation AddTheaterViewController


- (void)viewDidLoad
{
    self.title = self.titleBar;
    // Instantiate a Save button to invoke the save: method when tapped
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(save:)];
    self.deleteButton.hidden = YES;
    if([self.title isEqualToString:@"Edit Theater"]){
        self.deleteButton.hidden = NO;
        self.theaterName.text = self.theaterToEdit;
        self.theaterAddress.text = self.addressToEdit;
    }
    
    // Set up the Save custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (IBAction)keyboardDone:(id)sender
{
    [sender resignFirstResponder];  // Deactivate the keyboard
}

- (void)save:(id)sender
{
    if ([self.theaterName.text isEqualToString:@""] || [self.theaterAddress.text isEqualToString:@""] ){
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
    [self.delegate addTheaterViewController:self didFinishWithSave:YES];
    }
}

- (IBAction)delete:(id)sender {
    
}

- (IBAction)backgroundTouch:(UIControl*)sender {
    [sender resignFirstResponder];  // Deactivate the keyboard
}
@end
