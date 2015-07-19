//
//  AppDelegate.m
//  Music4You
//
//  Created by Peter Pike on 7/8/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong, nonatomic) CoreDataHelper *coreDataHelper;
@property (strong, nonatomic) PlayMusicViewController *pvc;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.coreDataHelper = [[CoreDataHelper alloc] init];
    self.coreDataHelper.context = [self managedObjectContext];
    self.playVC = self.pvc;
    // create Genre data
    [self prepareGenreDataForApp];
    NSLog(@"Genres and SubGenres are available");
    
    // create Chart data
    if ([self prepareChartDataForApp]) {
        NSLog(@"Charts are available");
    } else {
        NSLog(@"Error to creating Charts!");
    }
    
    // init an instance of song player
    self.song = [[AVPlayer alloc] init];
    
    [self incomingCallHandling];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkStatusNotification:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    return YES;
}
// prepare Genre and SubGenre data for App if no Genre and SubGenre data available
- (void) prepareGenreDataForApp {
    
    // check Genre data available
    NSArray *arrayGenres = [self.coreDataHelper fetchAllGenre];
    if (arrayGenres.count > 1) {
        return;
    }
    
    // create Genre data
    Genre *vietNam = [[Genre alloc] initWithGenreID:@"IWZ9Z08I" genreName:@"VIỆT NAM" managedObjectContext:self.managedObjectContext];
    Genre *auMy = [[Genre alloc] initWithGenreID:@"IWZ9Z08O" genreName:@"ÂU MỸ" managedObjectContext:self.managedObjectContext];
    Genre *chauA = [[Genre alloc] initWithGenreID:@"IWZ9Z08W" genreName:@"CHÂU Á" managedObjectContext:self.managedObjectContext];
    Genre *khongLoi = [[Genre alloc] initWithGenreID:@"IWZ9Z086" genreName:@"KHÔNG LỜI" managedObjectContext:self.managedObjectContext];
    
    // check SubGenre data available
    NSArray *arraySubGenres = [self.coreDataHelper fetchAllSubGenre];
    if (arraySubGenres.count > 1) {
        return;
    }
    
    // create subGenre of genre vietNam
    SubGenre *nhacTre = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z088" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Trẻ" managedObjectContext:self.managedObjectContext];
    [nhacTre setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacTre];
    
    SubGenre *nhacTruTinh = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08B" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Trữ Tình" managedObjectContext:self.managedObjectContext];
    [nhacTruTinh setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacTruTinh];
    
    SubGenre *danceViet = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0CW" genreID:@"IWZ9Z08I" subGenreName:@"Dance Việt" managedObjectContext:self.managedObjectContext];
    [danceViet setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:danceViet];
   
    SubGenre *rockViet = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08A" genreID:@"IWZ9Z08I" subGenreName:@"Rock Việt" managedObjectContext:self.managedObjectContext];
    [rockViet setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:rockViet];
   
    SubGenre *rapHipHopViet = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z089" genreID:@"IWZ9Z08I" subGenreName:@"Rap / Hip Hop Việt" managedObjectContext:self.managedObjectContext];
    [rapHipHopViet setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:rapHipHopViet];
   
    SubGenre *nhacTrinh = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08E" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Trịnh" managedObjectContext:self.managedObjectContext];
    [nhacTrinh setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacTrinh];
    
    SubGenre *nhacThieuNhi = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08F" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Thiếu Nhi" managedObjectContext:self.managedObjectContext];
    [nhacThieuNhi setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacThieuNhi];
    
    SubGenre *nhacCachMang = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08C" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Cách Mạng" managedObjectContext:self.managedObjectContext];
    [nhacCachMang setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacCachMang];
    
    SubGenre *nhacQueHuong = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08D" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Quê Hương" managedObjectContext:self.managedObjectContext];
    [nhacQueHuong setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacQueHuong];
    
    SubGenre *nhacKhongLoi = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z090" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Không Lời" managedObjectContext:self.managedObjectContext];
    [nhacKhongLoi setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacKhongLoi];
    
    SubGenre *nhacPhim = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0BA" genreID:@"IWZ9Z08I" subGenreName:@"Nhạc Phim" managedObjectContext:self.managedObjectContext];
    [nhacPhim setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:nhacPhim];
    
    SubGenre *caiLuong = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0C6" genreID:@"IWZ9Z08I" subGenreName:@"Cải Lương" managedObjectContext:self.managedObjectContext];
    [caiLuong setSubToGenre:vietNam];
    [vietNam addGenreToSubObject:caiLuong];
    
    // create subGenre of genre auMy
    SubGenre *pop = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z097" genreID:@"IWZ9Z08O" subGenreName:@"Pop" managedObjectContext:self.managedObjectContext];
    [pop setSubToGenre:auMy];
    [auMy addGenreToSubObject:pop];
    
    SubGenre *rock = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z099" genreID:@"IWZ9Z08O" subGenreName:@"Rock" managedObjectContext:self.managedObjectContext];
    [rock setSubToGenre:auMy];
    [auMy addGenreToSubObject:rock];
    
    SubGenre *rapHipHop = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z09B" genreID:@"IWZ9Z08O" subGenreName:@"Rap / Hip Hop" managedObjectContext:self.managedObjectContext];
    [rapHipHop setSubToGenre:auMy];
    [auMy addGenreToSubObject:rapHipHop];
    
    SubGenre *country = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z096" genreID:@"IWZ9Z08O" subGenreName:@"Country" managedObjectContext:self.managedObjectContext];
    [country setSubToGenre:auMy];
    [auMy addGenreToSubObject:country];
    
    SubGenre *electronicDance = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z09A" genreID:@"IWZ9Z08O" subGenreName:@"Electronic / Dance" managedObjectContext:self.managedObjectContext];
    [electronicDance setSubToGenre:auMy];
    [auMy addGenreToSubObject:electronicDance];
    
    SubGenre *rAndBSoul = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z09D" genreID:@"IWZ9Z08O" subGenreName:@"R&B / Soul" managedObjectContext:self.managedObjectContext];
    [rAndBSoul setSubToGenre:auMy];
    [auMy addGenreToSubObject:rAndBSoul];
    
    SubGenre *audiophile = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0EO" genreID:@"IWZ9Z08O" subGenreName:@"Audiophile" managedObjectContext:self.managedObjectContext];
    [audiophile setSubToGenre:auMy];
    [auMy addGenreToSubObject:audiophile];
    
    SubGenre *tranceHouseTechno = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0C7" genreID:@"IWZ9Z08O" subGenreName:@"Trance / House / Techno" managedObjectContext:self.managedObjectContext];
    [tranceHouseTechno setSubToGenre:auMy];
    [auMy addGenreToSubObject:tranceHouseTechno];
    
    SubGenre *oST = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0EC" genreID:@"IWZ9Z08O" subGenreName:@"OST" managedObjectContext:self.managedObjectContext];
    [oST setSubToGenre:auMy];
    [auMy addGenreToSubObject:oST];
    
    SubGenre *bluesJazz = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z09C" genreID:@"IWZ9Z08O" subGenreName:@"Blues / Jazz" managedObjectContext:self.managedObjectContext];
    [bluesJazz setSubToGenre:auMy];
    [auMy addGenreToSubObject:bluesJazz];
    
    SubGenre *newAgeWorldMusic = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z098" genreID:@"IWZ9Z08O" subGenreName:@"New Age / World Music" managedObjectContext:self.managedObjectContext];
    [newAgeWorldMusic setSubToGenre:auMy];
    [auMy addGenreToSubObject:newAgeWorldMusic];
    
    SubGenre *indie = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0CA" genreID:@"IWZ9Z08O" subGenreName:@"Indie" managedObjectContext:self.managedObjectContext];
    [indie setSubToGenre:auMy];
    [auMy addGenreToSubObject:indie];
    
    SubGenre *folk = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z09E" genreID:@"IWZ9Z08O" subGenreName:@"Folk" managedObjectContext:self.managedObjectContext];
    [folk setSubToGenre:auMy];
    [auMy addGenreToSubObject:folk];
    
    SubGenre *christianAndGospel = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0DE" genreID:@"IWZ9Z08O" subGenreName:@"Christian & Gospel" managedObjectContext:self.managedObjectContext];
    [christianAndGospel setSubToGenre:auMy];
    [auMy addGenreToSubObject:christianAndGospel];
    
    // create subGenre of genre chauA
    SubGenre *hanQuoc = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08W" genreID:@"IWZ9Z08W" subGenreName:@"Hàn Quốc" managedObjectContext:self.managedObjectContext];
    [hanQuoc setSubToGenre:chauA];
    [chauA addGenreToSubObject:hanQuoc];
    
    SubGenre *nhatBan = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08Z" genreID:@"IWZ9Z08W" subGenreName:@"Nhật Bản" managedObjectContext:self.managedObjectContext];
    [nhatBan setSubToGenre:chauA];
    [chauA addGenreToSubObject:nhatBan];
    
    SubGenre *hoaNgu = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z08U" genreID:@"IWZ9Z08W" subGenreName:@"Hoa Ngữ" managedObjectContext:self.managedObjectContext];
    [hoaNgu setSubToGenre:chauA];
    [chauA addGenreToSubObject:hoaNgu];
    
    // create subGenre of genre khongLoi
    SubGenre *classical = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0BI" genreID:@"IWZ9Z086" subGenreName:@"Classical" managedObjectContext:self.managedObjectContext];
    [classical setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:classical];
    
    SubGenre *piano = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0B0" genreID:@"IWZ9Z086" subGenreName:@"Piano" managedObjectContext:self.managedObjectContext];
    [piano setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:piano];
    
    SubGenre *guitar = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0A9" genreID:@"IWZ9Z086" subGenreName:@"Guitar" managedObjectContext:self.managedObjectContext];
    [guitar setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:guitar];
    
    SubGenre *violin = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0BU" genreID:@"IWZ9Z086" subGenreName:@"Violin" managedObjectContext:self.managedObjectContext];
    [violin setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:violin];
    
    SubGenre *cello = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0AD" genreID:@"IWZ9Z086" subGenreName:@"Cello" managedObjectContext:self.managedObjectContext];
    [cello setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:cello];
    
    SubGenre *saxophone = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0B7" genreID:@"IWZ9Z086" subGenreName:@"Saxophone" managedObjectContext:self.managedObjectContext];
    [saxophone setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:saxophone];
    
    SubGenre *nhacCuDanToc = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0AA" genreID:@"IWZ9Z086" subGenreName:@"Nhạc Cụ Dân Tộc" managedObjectContext:self.managedObjectContext];
    [nhacCuDanToc setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:nhacCuDanToc];
    
    SubGenre *nonLyrNewAgeWorldMusic = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0BO" genreID:@"IWZ9Z086" subGenreName:@"New Age / World Music" managedObjectContext:self.managedObjectContext];
    [nonLyrNewAgeWorldMusic setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:nonLyrNewAgeWorldMusic];
    
    SubGenre *nhacCuKhac = [[SubGenre alloc] initWithSubGenreID:@"IWZ9Z0E8" genreID:@"IWZ9Z086" subGenreName:@"Nhạc Cụ Khác" managedObjectContext:self.managedObjectContext];
    [nhacCuKhac setSubToGenre:khongLoi];
    [khongLoi addGenreToSubObject:nhacCuKhac];
    
    // save context
    [self.coreDataHelper saveContext];
}

// prepare Chart data for App if no Chart data available
- (BOOL) prepareChartDataForApp {
    NSArray *arrayCharts = [self.coreDataHelper fetchAllChart];
    
    // check Chart data available
    if (arrayCharts.count > 1) {
        return YES;
    }
    
    // create Chart data
    Chart *vietNamChart = [[Chart alloc] initWithID:@"IWZ9Z08I" chartName:@"VIỆT NAM" managedObjectContext:self.managedObjectContext];
    
    Chart *auMyChart = [[Chart alloc] initWithID:@"IWZ9Z0BW" chartName:@"ÂU MỸ" managedObjectContext:self.managedObjectContext];
    
    Chart *hanQuocChart = [[Chart alloc] initWithID:@"IWZ9Z0BO" chartName:@"HÀN QUỐC" managedObjectContext:self.managedObjectContext];
    
    if (!vietNamChart || !auMyChart || !hanQuocChart) {
        return NO;
    }
    
    [self.coreDataHelper saveContext];
    return YES;
}

- (void)incomingCallHandling {
    CTCallCenter * _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall* call)
    {
        
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            //NSLog(@"Call has been disconnected");
            [self.song play];
        }
        else if([call.callState isEqualToString:CTCallStateDialing])
        {
            //NSLog(@"Call start");
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            
            //NSLog(@"Call has just been connected");
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            //NSLog(@"Call is incoming");
            // You have to initiate/post your local notification through NSNotification center like this
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopAVPlayer" object:nil];
            [self.song pause];
        } else
        {
            //NSLog(@"None of the conditions");
        }
        
        
    };
}

- (void)handleNetworkStatusNotification:(NSNotification *)note {
    Reachability* curReach = [note object];
    NetworkStatus status = curReach.currentReachabilityStatus;
    NSString *statusString;
    switch (status) {
        case NotReachable: {
            [self.song pause];
            statusString = @"Not Reachable";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:statusString message:@"Check your internet connection" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles: nil];
            [alertView show];
            
        }
            break;
//        case ReachableViaWiFi:
//            statusString = @"Wifi";
//            break;
//        case ReachableViaWWAN:
//            statusString = @"WWAN";
//            break;
//            
        default:
            break;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "tinhvan.Music4You" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Music4You" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Music4You.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
