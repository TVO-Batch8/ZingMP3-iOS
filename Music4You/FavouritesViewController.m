//
//  FavouritesViewController.m
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "FavouritesViewController.h"

@interface FavouritesViewController ()
@property (strong, nonatomic) CoreDataHelper *coreDataHelper;
@property (strong, nonatomic) PlayMusicViewController *playMusicVC;
@end

@implementation FavouritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coreDataHelper = [[CoreDataHelper alloc] init];
    self.managedObjectContext = [self managedObjectContext];
    self.coreDataHelper.context = self.managedObjectContext;
    self.arrayFavourites = [NSMutableArray arrayWithObjects:nil];
    [self.tableFavourite setHidden:YES];
    [self.navigationItem setTitle:@"Favourites"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.arrayFavourites removeAllObjects];
    [self.arrayFavourites addObjectsFromArray:[self.coreDataHelper fetchAllFavoutite]];
    if (self.arrayFavourites.count >= 1) {
        [self.tableFavourite setHidden:NO];
        [self.lbNoFavourite setHidden:YES];
    } else {
        [self.tableFavourite setHidden:YES];
        [self.lbNoFavourite setHidden:NO];
    }
    
    [self.tableFavourite reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayFavourites.count == 0) {
        return 1;
    }
    return self.arrayFavourites.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:favouriteCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:favouriteCellID];
    }
    if (self.arrayFavourites.count != 0) {
        Favourite *favourite = [self.arrayFavourites objectAtIndex:indexPath.row];
        [cell.textLabel setText:favourite.songTitle];
        [cell.detailTextLabel setText:favourite.artist];
        [cell.imageView setImage:[UIImage imageNamed:@"loading.png"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *urlImage = [NSURL URLWithString:favourite.artistAvatar];
            NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.imageView setImage:[UIImage imageWithData:dataImage]];
            });
        });
    } else {
        [cell.textLabel setText:@"No Favourite"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.arrayFavourites.count > 0) {
        Favourite *favourite = [self.arrayFavourites objectAtIndex:indexPath.row];
        if ([self.coreDataHelper deleteFavourite:favourite]) {
            NSString *message = [NSString stringWithFormat:@"You unlike %@", favourite.songTitle];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            });
            
            [self.arrayFavourites removeObject:favourite];
            [self.coreDataHelper saveContext];
            
            
            
            [tableView reloadData];
            if (self.arraySong.count == 0) {
                [self.tableFavourite setHidden:YES];
                [self.lbNoFavourite setHidden:NO];
            }
        }
        NSLog(@"Delete OK");
    }
}
#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[((AppDelegate *)([UIApplication sharedApplication].delegate)).song pause];
    [self performSegueWithIdentifier:@"segueFavourite" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int selectedIndex = (int)self.tableFavourite.indexPathForSelectedRow.row;
    if ([segue.identifier isEqualToString:@"segueFavourite"]) {
        self.playMusicVC = (PlayMusicViewController *)segue.destinationViewController;
//        if (self.playMusicVC) {
//            [((AppDelegate *)([UIApplication sharedApplication].delegate)).song pause];
//        }
        if (!self.playMusicVC.arraySong) {
            self.playMusicVC.arraySong = [NSMutableArray array];
        } else {
            [self.playMusicVC.arraySong removeAllObjects];
        }
        // iD, title, artist, artistAvatar, composer, linkPlay
        for (int i = 0; i < self.arrayFavourites.count; i++) {
            Favourite *favourite = [self.arrayFavourites objectAtIndex:i];
            NSString *songID = favourite.songID;
            NSString *title = favourite.songTitle;
            NSString *artist = favourite.artist;
            NSString *artistAvatar = favourite.artistAvatar;
            NSString *composer = favourite.composer;
            NSString *linkPlay128 = favourite.linkPlay128;
            NSArray *songs = [NSArray arrayWithObjects:songID, title, artist, artistAvatar, composer, linkPlay128, nil];
            [self.playMusicVC.arraySong addObject:songs];
        }
        
        self.playMusicVC.currentIndex = selectedIndex;
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
