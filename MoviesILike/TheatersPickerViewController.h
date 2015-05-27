//
//  TheatersPickerViewController.h
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/21/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddTheaterViewController.h"



@interface TheatersPickerViewController : UIViewController<CLLocationManagerDelegate, AddTheaterViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *showTheater;
@property (strong, nonatomic) IBOutlet UISegmentedControl *getDirections;
- (IBAction)showOnMap:(id)sender;
- (IBAction)getDirectionToTheater:(id)sender;


@end
