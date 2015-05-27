//
//  MoviesViewController.m
//  MoviesILike
//
//  Created by Mike_Gazdich_rMBP on 11/14/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTrailerViewController.h"
#import "AddMovieViewController.h"
#import "AppDelegate.h"

@interface MoviesViewController ()

@property (nonatomic, strong) NSMutableDictionary *movieGenres;
@property (nonatomic, strong) NSMutableArray *genres;

// cityData is the data object to be passed to the downstream view controller
//@property (nonatomic, strong) NSMutableArray *genreData;

//movieData is the used to pass the movie data downstream to the MovieTrailerViewController
@property (nonatomic, strong) NSArray *movieData;

// This method is invoked when the user taps the Add button created at run time.
- (void)addMovie:(id)sender;

@end

@implementation MoviesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    // Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Set the local instance variable to the obj ref of the countryCities dictionary
    // data structure created in the App Delegate class
    self.movieGenres = appDelegate.movieGenres;
    
    // Set up the Edit system button on the left of the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    /*
     editButtonItem is provided by the system with its own functionality. Tapping it triggers editing by
     displaying the red minus sign icon on all rows. Tapping the minus sign displays the Delete button.
     The Delete button is handled in the method tableView: commitEditingStyle: forRowAtIndexPath:
     */
    
    // Instantiate an Add button (with plus sign icon) to invoke the addCity: method when tapped.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addMovie:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Obtain a sorted list of genre names and store them in a mutable array
    NSArray *sortedGenreNames = [[self.movieGenres allKeys] sortedArrayUsingSelector:@selector(compare:)];

    // Set the mutable sorted array to countries
    self.genres = [[NSMutableArray alloc] initWithArray:sortedGenreNames];
    
    // Instantiate the City Data object to pass to the downstream view controller
    self.movieData = [[NSArray alloc] init];
    
    [super viewDidLoad];

}

#pragma mark - Add Movie Method

// The addCity: method is invoked when the user taps the Add button created at run time.
- (void)addMovie:(id)sender
{
    // Perform the segue named AddCity
    [self performSegueWithIdentifier:@"addMovie" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddMovieViewControllerDelegate Protocol Method

/*
 This is the AddCityViewController's delegate method we created. AddCityViewController informs
 the delegate CityViewController that the user tapped the Save button if the parameter is YES.
 */
- (void)addMovieViewController:(AddMovieViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        // Get the country name entered by the user on the AddCityViewController's UI
        NSString *movieNameEntered = controller.movieName.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *topStarsEntered = controller.topStars.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *primGenreEntered = controller.primGenre.text;
        
        // Get the city name entered by the user on the AddCityViewController's UI
        NSString *youTubeIDEntered = controller.youTubeID.text;
                                      
        NSMutableArray *newValue = [[NSMutableArray alloc] init];
        [newValue addObject: movieNameEntered];
        [newValue addObject: topStarsEntered];
        [newValue addObject: youTubeIDEntered];
        [newValue addObject: [controller.ratingSegView titleForSegmentAtIndex:[controller.ratingSegView selectedSegmentIndex]]];
        if ([self.genres containsObject:primGenreEntered]) {
            
            // Get the list of current cities for the country name entered
            NSMutableDictionary *moviesForGenreEntered = [self.movieGenres objectForKey:primGenreEntered];
            
            NSArray *moviesStatic = [[moviesForGenreEntered allKeys]sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *movies = [[NSMutableArray alloc] initWithArray:moviesStatic];

            NSInteger nextValue = [[movies objectAtIndex:[movies count]-1] integerValue];
            nextValue++;
            NSString *newKey = [NSString stringWithFormat:@"%d", nextValue];
            
            // Add the new city to that list
            [moviesForGenreEntered setValue:newValue forKey:newKey];
            // Set the new list of cities for the country name entered
            [self.movieGenres setValue:moviesForGenreEntered forKey:primGenreEntered];
            
        }
        else {  // The entered country name does not exist in the current dictionary
            // Create a mutable array containing cityNameEntered
            NSMutableDictionary *genreNameEntered = [[NSMutableDictionary alloc]init];
            [genreNameEntered setValue:newValue forKey:@"1"];
            [self.movieGenres setValue:genreNameEntered forKey:primGenreEntered];

        }
        
        // Obtain a sorted list of country names and store them in a mutable array
        NSArray *sortedGenreNames = [[self.movieGenres allKeys]sortedArrayUsingSelector:@selector(compare:)];
        
        self.genres = [[NSMutableArray alloc]initWithArray:sortedGenreNames];  // Set the mutable sorted array to countries
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.moviesTableView reloadData];
    }
    
    /*
     Pop the current view controller AddCityViewController from the stack
     and show the next view controller in the stack, which is ViewController.
     */
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.genres count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *markedGenre = [self.genres objectAtIndex:section];
    NSMutableArray *moviesInGenre = [self.movieGenres objectForKey:markedGenre];
    return [moviesInGenre count];
}

// Set the table view section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.genres objectAtIndex:section];
}

// Customize the appearance of the table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movie"];
    
    // Configure the cell
    NSUInteger sectionNumber = [indexPath section];
    NSUInteger rowNumber = [indexPath row];
    
    NSString *markedGenre = [self.genres objectAtIndex:sectionNumber];
    NSMutableDictionary *markedMovies = [self.movieGenres objectForKey:markedGenre];
    
    NSArray *movies = [[markedMovies allKeys]sortedArrayUsingSelector:@selector(compare:)];

    NSArray *movie = [markedMovies objectForKey:[movies objectAtIndex:rowNumber]];
    cell.textLabel.text = [movie objectAtIndex:0];
    cell.detailTextLabel.text = [movie objectAtIndex:1];
    NSString *rating = [movie objectAtIndex:3];
    cell.imageView.image = [UIImage imageNamed:rating];
    
    /*
     Set up a detail disclosure button to be displayed on the right side of each row.
     The button is handled in the method tableView: accessoryButtonTappedForRowWithIndexPath:
     */
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// We allow each row (city) of the table view to be editable, i.e., deletable or movable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// This is the method invoked when the user taps the Delete button in the Edit mode
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // Handle the Delete action
        
        NSString *movieGenreToDelete = [self.genres objectAtIndex:[indexPath section]];
        NSMutableDictionary *currentMovies = [self.movieGenres objectForKey:movieGenreToDelete];
        NSArray *movies = [[currentMovies allKeys]sortedArrayUsingSelector:@selector(compare:)];
        NSString *movie = [movies objectAtIndex:[indexPath row]];
        
        [currentMovies removeObjectForKey: movie];  // Remove the city marked for delete
        
        if ([currentMovies count] == 0) {
            // If no city exists in the currentCities array after deletion, then we need to also delete the country.
            [self.movieGenres removeObjectForKey:movieGenreToDelete];
            
            // Obtain a sorted list of movie genres and store them in a static array
            NSArray *sortedMovieGenresInStaticArray = [[self.movieGenres allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
            // Instantiate a new NSMutableArray object to hold the movie genres in a mutable (changeable) array
            NSMutableArray *sortedMovieGenres = [[NSMutableArray alloc] initWithArray:sortedMovieGenresInStaticArray];
            //-------------------------------------------------------------------------------------------

            self.genres = sortedMovieGenres;
        }
        else {
            // Set the new list of cities for the country
            [self.movieGenres setValue:currentMovies forKey:movieGenreToDelete];
        }
        
        // Reload the rows and sections of the Table View countryCityTableView
        [self.moviesTableView reloadData];
    }
}

/*
 This method is invoked to carry out the row (city) movement after the method
 tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath: approved the move.
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *genreNameFrom = [self.genres objectAtIndex:[fromIndexPath section]];
    
        NSMutableDictionary *genreDict =[self.movieGenres objectForKey:genreNameFrom];
        NSArray *moviesStatic = [[genreDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray *movies = [[NSMutableArray alloc] initWithArray:moviesStatic];

        NSUInteger rowNumberFrom = fromIndexPath.row;
        NSUInteger rowNumberTo = toIndexPath.row;
    
    if (rowNumberFrom < rowNumberTo){
        
        for (int i = rowNumberFrom; i < rowNumberTo; i++){
            NSString *movieKeyToMoveFrom = [movies objectAtIndex:i];
            NSString *movieKeyToMoveTo = [movies objectAtIndex:i+1];
    
            NSArray *movieDataToMoveFrom = [genreDict valueForKey:movieKeyToMoveFrom];
            NSArray *movieDataToMoveTo = [genreDict valueForKey:movieKeyToMoveTo];
    
            [genreDict setValue:movieDataToMoveFrom forKeyPath:movieKeyToMoveTo];
            [genreDict setValue:movieDataToMoveTo forKeyPath:movieKeyToMoveFrom];
        }
    }
    else{
        
        for (int i = rowNumberFrom; i > rowNumberTo; i--){
            NSString *movieKeyToMoveFrom = [movies objectAtIndex:i];
            NSString *movieKeyToMoveTo = [movies objectAtIndex:i-1];
            
            NSArray *movieDataToMoveFrom = [genreDict valueForKey:movieKeyToMoveFrom];
            NSArray *movieDataToMoveTo = [genreDict valueForKey:movieKeyToMoveTo];
            
            [genreDict setValue:movieDataToMoveFrom forKeyPath:movieKeyToMoveTo];
            [genreDict setValue:movieDataToMoveTo forKeyPath:movieKeyToMoveFrom];
        }
    }
        
    
//    [self.genres setValue:genreDict forKeyPath:genreName ];
//    [movies replaceObjectAtIndex:rowNumberTo withObject:movieToMoveFrom];
//    [movies replaceObjectAtIndex:rowNumberFrom withObject:movieToMoveTo];
    
    // After the change of order, set the countryCities dictionary with the new list of cities
    //[self.genres setObject:movies forKey:genre];
    
    // No need to reload the table view data since the view is updated automatically
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

// Allow the movement of each row (city)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate Protocol Methods

// Tapping a row displays an alert panel informing the user for the selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedGenreName = [self.genres objectAtIndex:[indexPath section]];
    NSMutableDictionary *moviesForSelectedGenre = [self.movieGenres objectForKey:selectedGenreName];
    NSString *movie = [[[moviesForSelectedGenre allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:[indexPath row]];
    self.movieData = [moviesForSelectedGenre valueForKey:movie];
    
    // Perform the segue named trailer
    [self performSegueWithIdentifier:@"trailer" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Preparing for Segue

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"addMovie"]) {
        
        // Obtain the object reference of the destination view controller
        AddMovieViewController *addMovieViewController = [segue destinationViewController];
        
        // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
        addMovieViewController.delegate = self;
        
    } else if ([segueIdentifier isEqualToString:@"trailer"]) {
        
        // Obtain the object reference of the destination view controller
        MovieTrailerViewController *movieTrailerViewController = [segue destinationViewController];
        
        // Pass the cityData array obj ref to downstream CityMapViewController
        movieTrailerViewController.movieData = self.movieData;
        
    }
}


@end

