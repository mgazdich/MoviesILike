//
//  TheatersPickerViewController.m
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/21/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "TheatersPickerViewController.h"
#import "AppDelegate.h"
#import "AddressMapViewController.h"
#import "AddTheaterViewController.h"

@interface TheatersPickerViewController ()

@property (strong, nonatomic) NSMutableDictionary  *theaterNamesDict;
@property (strong, nonatomic) NSMutableArray       *theaterNames;
//@property (strong, nonatomic) NSDictionary  *vtPlaceData;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSString      *googleMapQuery;

@property (strong, nonatomic) NSString      *addressSelected;
@property (strong, nonatomic) NSString      *toPlaceSelected;

@property (strong, nonatomic) NSString *theaterToEdit;
@property (strong, nonatomic) NSString *addressToEdit;
@property (strong, nonatomic) NSString *titleBar;


@property (strong, nonatomic) NSString      *directionsType;
@property (strong, nonatomic) NSString      *mapsHtmlAbsoluteFilePath;

- (void) addTheater:(id)sender;
@end

@implementation TheatersPickerViewController

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
    // Obtain the object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                   target:self action:@selector(editTheater:)];
     // Set up the Edit system button on the left of the navigation bar
    self.navigationItem.leftBarButtonItem = editButton;// Instantiate an Add button (with plus sign icon) to invoke the addCity: method when tapped.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addTheater:)];
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    // Obtain the object reference to the vtPlaceNameDict dictionary object created in the App Delegate class
    self.theaterNamesDict = appDelegate.theaterNamesDict;
    
    // Obtain a sorted list of genre names and store them in a mutable array
    NSArray *sortedTheaters = [[self.theaterNamesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    // Obtain the object reference to the vtPlaceNames array object created in the App Delegate class
    self.theaterNames = [[NSMutableArray alloc] initWithArray:sortedTheaters];
    
    // Obtain the relative file path to the maps.html file in the main bundle
    NSURL *mapsHtmlRelativeFilePath = [[NSBundle mainBundle] URLForResource:@"maps" withExtension:@"html"];
    
    // Obtain the absolute file path to the maps.html file in the main bundle
    self.mapsHtmlAbsoluteFilePath = [mapsHtmlRelativeFilePath absoluteString];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Obtain the number of the row in the middle of the VT place names list
    int numberOfRowToShow = (int)([self.theaterNames count] / 2);
    
    // Show the picker view of VT place names from the middle
    [self.pickerView selectRow:numberOfRowToShow inComponent:0 animated:NO];
    
    // Deselect the earlier selected directions type
    [self.showTheater setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self.getDirections setSelectedSegmentIndex:UISegmentedControlNoSegment];

}

#pragma mark - Add Movie Method

// The addCity: method is invoked when the user taps the Add button created at run time.
- (void)addTheater:(id)sender
{
    // Perform the segue named AddCity
    self.titleBar = @"Add Theater";
    [self performSegueWithIdentifier:@"addTheater" sender:self];
}

// The addCity: method is invoked when the user taps the Add button created at run time.
- (void)editTheater:(id)sender
{
    self.titleBar = @"Edit Theater";
    self.theaterToEdit = [self.theaterNames objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    self.addressToEdit = [self.theaterNamesDict valueForKey:self.theaterToEdit];
//    self.theaterToEdit = self.pickerView.
    // Perform the segue named AddCity
    [self performSegueWithIdentifier:@"addTheater" sender:self];
}

#pragma mark - AddMovieViewControllerDelegate Protocol Method

/*
 This is the AddCityViewController's delegate method we created. AddCityViewController informs
 the delegate CityViewController that the user tapped the Save button if the parameter is YES.
 */
- (void)addTheaterViewController:(AddTheaterViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        // Get the country name entered by the user on the AddCityViewController's UI
        NSString *theaterNameEntered = controller.theaterName.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *theaterAddressEntered = controller.theaterAddress.text;

        if ([self.theaterNames containsObject:theaterNameEntered]) {
            
            [self.theaterNamesDict setValue:theaterAddressEntered forKey:theaterNameEntered];
        }
        else {  // The entered country name does not exist in the current dictionary
            // Create a mutable array containing cityNameEntered
            [self.theaterNamesDict setValue:theaterAddressEntered forKey:theaterNameEntered];
        }
        
        
        NSArray *sortedNewTheaters = [[self.theaterNamesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        self.theaterNames = [[NSMutableArray alloc]initWithArray:sortedNewTheaters];  // Set the mutable sorted array to countries
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.pickerView reloadAllComponents];
    }
    
    /*
     Pop the current view controller AddCityViewController from the stack
     and show the next view controller in the stack, which is ViewController.
     */
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showOnMap:(id)sender {
    NSInteger selectedRowNumber = [self.pickerView selectedRowInComponent:0];
    NSString *theaterName = [self.theaterNames objectAtIndex:selectedRowNumber];
    NSString *theaterAddress = [self.theaterNamesDict valueForKey:theaterName];
    self.addressSelected = theaterName;
    
    // If no address is entered, alert the user
    if ([theaterAddress isEqualToString:@""]) {
        
        // Create and display an error message
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                               message:@"Please enter an address to show on map!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
        
        [alertMessage show];
        return;
    }
    
    
    // Replace all occurrences of space in the address with +
    NSString *addressToShowOnMap = [theaterAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    switch ([self.showTheater selectedSegmentIndex]) {
            
        case 0:   // Roadmap map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=ROADMAP&zoom=16", addressToShowOnMap];
            break;
            
        case 1:   // Satellite map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=SATELLITE&zoom=16", addressToShowOnMap];
            break;
            
        case 2:   // Hybrid map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=HYBRID&zoom=16", addressToShowOnMap];
            break;
            
        case 3:   // Terrain map type selected
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?place=%@&maptype=TERRAIN&zoom=16", addressToShowOnMap];
            break;
            
        default:
        {
            // Create and display an error message
            UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:@"Selection Missing"
                                                                   message:@"Please select a map type!"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Okay"
                                                         otherButtonTitles:nil];
            [alertMessage show];
            return;
        }
            
    }
    // Perform the segue named Address
    [self performSegueWithIdentifier:@"map" sender:self];
}

- (IBAction)getDirectionToTheater:(id)sender {
    /*
    IMPORTANT NOTE: Current GPS location cannot be determined under the iOS Simulator
    on your laptop or desktop computer because those computers do NOT have a GPS antenna.
        Therefore, do NOT expect the code herein to work under the iOS Simulator!
            
            You must deploy your location-aware app to an iOS device to be able to test it properly.
            
            To develop a location-aware app:
            
            (1) Link to CoreLocation.framework in your Xcode project
            (2) Include #import <CoreLocation/CoreLocation.h> to use its classes.
            (3) Study documentation on CLLocation, CLLocationManager, and CLLocationManagerDelegate
            */
            
        /*
         The user can turn off location services on an iOS device in Settings.
         First, you must check to see of it is turned off or not.
         */
            
            if ([CLLocationManager locationServicesEnabled] == NO) {
                
                // Create the Alert View
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                message:@"Turn Location Services On in your device settings to be able to use location services."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil];
                
                // Display the Alert View
                [alert show];
                
                return;
            }
    
    // Instantiate a CLLocationManager object and store its object reference
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Set the current view controller to be the delegate of the location manager object
    self.locationManager.delegate = self;
    
    // Set the location manager's distance filter to kCLDistanceFilterNone implying that
    // a location update will be sent regardless of movement of the device
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    // Set the location manager's desired accuracy within ten meters of the desired target
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Start the generation of updates that report the user’s current location.
    // Implement the protocol method below to receive and process the location info.
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate Methods

// Tells the delegate that a new location data is available
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    /*
     The objects in the given locations array are ordered with respect to their occurrence times.
     Therefore, the most recent location update is at the end of the array; hence, we access the last object.
     */
    CLLocation *currentLocation = [locations lastObject];
    
    // Obtain current location's latitude in degrees (as a double value)
    double latitudeValue = currentLocation.coordinate.latitude;
    NSNumber *lat = [NSNumber numberWithDouble:latitudeValue];
    
    // Obtain current location's longitude in degrees (as a double value)
    double longitudeValue = currentLocation.coordinate.longitude;
    NSNumber *lng = [NSNumber numberWithDouble:longitudeValue];
    
    NSInteger selectedRowNumber = [self.pickerView selectedRowInComponent:0];
    NSString *theaterName = [self.theaterNames objectAtIndex:selectedRowNumber];
    NSString *theaterAddress = [self.theaterNamesDict valueForKey:theaterName];
    self.addressSelected = [self.getDirections titleForSegmentAtIndex:[self.getDirections selectedSegmentIndex]];
    
    
    // Obtain a new string in which all occurrences of space in the address are replaced by +
    NSString *addressFrom = [NSString stringWithFormat:@"%@,%@", [lat stringValue], [lng stringValue]];
    
    NSString *addressTo = [theaterAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    
    switch ([self.getDirections selectedSegmentIndex]) {
            
        case 0:  // Compose the Google directions query for DRIVING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=DRIVING", addressFrom, addressTo];
            self.directionsType = @"Driving";
            break;
            
        case 1:  // Compose the Google directions query for WALKING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=WALKING", addressFrom, addressTo];
            self.directionsType = @"Walking";
            break;
            
        case 2:  // Compose the Google directions query for BICYCLING
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=BICYCLING", addressFrom, addressTo];
            self.directionsType = @"Bicycling";
            break;
            
        case 3:  // Compose the Google directions query for TRANSIT
            
            self.googleMapQuery = [self.mapsHtmlAbsoluteFilePath stringByAppendingFormat:@"?start=%@&end=%@&traveltype=TRANSIT", addressFrom, addressTo];
            self.directionsType = @"Transit";
            break;
            
        default:
            return;
    }
    
    // Stops the generation of location updates since we do not need it anymore
    [manager stopUpdatingLocation];
    // Perform the segue named CampusDirections
    [self performSegueWithIdentifier:@"map" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
     The kCLErrorLocationUnknown error implies that the manager is currently unable to get the location.
     We can ignore this error for the scenario of getting a single location fix, because we already
     have a timeout that will stop the location manager to save power.
     */
    if ([error code] == kCLErrorLocationUnknown) {
        
        // Create the Alert View
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Obtain Your Location"
                                                        message:@"Your location could not be determined!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        
        // Display the Alert View
        [alert show];
        
        // Stop the generation of location updates since we do not need it anymore
        [manager stopUpdatingLocation];
    }
}

#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.theaterNames count];
}


#pragma mark - Picker Delegate Method

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [self.theaterNames objectAtIndex:row];
}

#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"map"]) {
        
        // Obtain the object reference of the destination view controller
        AddressMapViewController *addressMapViewController = [segue destinationViewController];
        
        // Pass the data object _addressToShowOnMap to the destination view controller object
        addressMapViewController.googleMapQuery = self.googleMapQuery;
        addressMapViewController.adressEnteredToShowOnMap = self.addressSelected;
    }
    else if ([[segue identifier] isEqualToString:@"addTheater"]){
        AddTheaterViewController * addTheaterViewController = [segue destinationViewController];
        addTheaterViewController.titleBar = self.titleBar;
        if([self.titleBar isEqualToString:@"Edit Theater"]){
            addTheaterViewController.theaterToEdit = self.theaterToEdit;
            addTheaterViewController.addressToEdit  = self.addressToEdit;
        }
        addTheaterViewController.delegate = self;
    }
}
@end
