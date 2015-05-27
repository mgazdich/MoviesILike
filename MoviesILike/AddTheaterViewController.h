//
//  AddTheaterViewController.h
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/22/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTheaterViewControllerDelegate;

@interface AddTheaterViewController : UIViewController
@property (nonatomic, assign) id <AddTheaterViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *theaterName;
@property (strong, nonatomic) IBOutlet UITextField *theaterAddress;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) NSString *theaterToEdit;
@property (strong, nonatomic) NSString *addressToEdit;
@property (strong, nonatomic) NSString *titleBar;

- (IBAction)delete:(id)sender;


- (IBAction)backgroundTouch:(UIControl*)sender;

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
@protocol AddTheaterViewControllerDelegate

- (void)addTheaterViewController:(AddTheaterViewController *)controller didFinishWithSave:(BOOL)save;

@end