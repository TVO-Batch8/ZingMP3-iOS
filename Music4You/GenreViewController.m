//
//  GenreViewController.m
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "GenreViewController.h"
#import "SongListViewController.h"

@interface GenreViewController ()

@property (strong, nonatomic) CoreDataHelper *coreDataHelper;
@property (nonatomic) int sectionSelected;

@end

@implementation GenreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setTitle:@"Genre"];
    self.coreDataHelper = [[CoreDataHelper alloc] init];
    self.managedObjectContext = [self managedObjectContext];
    self.coreDataHelper.context = self.managedObjectContext;
    
    self.arrayGenres = [NSMutableArray arrayWithArray:[self.coreDataHelper fetchAllGenre]];
    self.arraySubGenres = [NSMutableArray arrayWithArray:[self.coreDataHelper fetchAllSubGenre]];
    
    NSLog(@"Genre APIs: %@", [APIs getAPIsSubGenreDetailWithID:@"IWZ9Z08E" onPage:@"1"]);
    // Do any additional setup after loading the view.
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Genre *genre = [self.arrayGenres objectAtIndex:section];
    return genre.genreName;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Genre *genre = [self.arrayGenres objectAtIndex:section];
    NSArray *subGenres = [self.coreDataHelper querySubGenresWithGenreID:genre.genreID];
    return subGenres.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
//    [viewHeader setBackgroundColor:[UIColor greenColor]];
//    return viewHeader;
//}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:genreCellID];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:genreCellID];
    }
    Genre *genre = [self.arrayGenres objectAtIndex:indexPath.section];
    NSArray *subGenres = [self.coreDataHelper querySubGenresWithGenreID:genre.genreID];
    SubGenre *subGenre = [subGenres objectAtIndex:indexPath.row];
    [cell.textLabel setText:subGenre.subGenreName];
    [cell.imageView setImage:[UIImage imageNamed:@"music.png"]];
    return cell;
}


#pragma mark - UITableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueGenre" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int subGenreSelectedIndex = (int)self.tableGenre.indexPathForSelectedRow.row;
    if ([segue.identifier isEqualToString:@"segueGenre"]) {
        
        SongListViewController *songListVC = (SongListViewController *)segue.destinationViewController;
        Genre *genre = [self.arrayGenres objectAtIndex:self.tableGenre.indexPathForSelectedRow.section];
        NSArray *subGenres = [self.coreDataHelper querySubGenresWithGenreID:genre.genreID];
        SubGenre *subGenre = [subGenres objectAtIndex:subGenreSelectedIndex];
        songListVC.stringSubGenreID = subGenre.subGenreID;
        songListVC.stringSubGenreName = subGenre.subGenreName;
        songListVC.downloadedData = nil;
        [songListVC.arraySong removeAllObjects];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
