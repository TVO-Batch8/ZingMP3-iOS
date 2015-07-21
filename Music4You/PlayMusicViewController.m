//
//  PlayMusicViewController.m
//  Music4You
//
//  Created by Peter Pike on 7/14/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "PlayMusicViewController.h"

@interface PlayMusicViewController () {
    CGPoint touchedPoint;
}

@property (strong, nonatomic) CoreDataHelper *coreDataHelper;

@property (weak, nonatomic) IBOutlet UIButton *btnFavourite;

@property (weak, nonatomic) IBOutlet UIImageView *iVAvatar;

@property (strong, nonatomic) AutoScrollLabel *autoScrollLabelTitle;
@property (strong, nonatomic) AutoScrollLabel *autoScrollLabelArtist;
@property (strong, nonatomic) AutoScrollLabel *autoScrollLabelComposer;
@property (weak, nonatomic) IBOutlet UILabel *lbArtist;
@property (weak, nonatomic) IBOutlet UILabel *lbComposer;
@property (weak, nonatomic) IBOutlet UILabel *lbNo;

@property (weak, nonatomic) IBOutlet UIButton *btnShuffle;
@property (weak, nonatomic) IBOutlet UIButton *btnRepeat;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *lbCurrent;
@property (weak, nonatomic) IBOutlet UILabel *lbRemain;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;

@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) NSTimer *timer;
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[[UIApplication sharedApplication].keyWindow addSubview:self.viewNowPlaying];
    
    self.coreDataHelper = [[CoreDataHelper alloc] init];
    self.managedObjectContext = [self managedObjectContext];
    self.coreDataHelper.context = self.managedObjectContext;
    
    self.iVAvatar.layer.cornerRadius = 82;
    self.iVAvatar.layer.masksToBounds = YES;
    
    self.song = ((AppDelegate *)([UIApplication sharedApplication].delegate)).song;
    //self.isPlayingSongSelected = NO;
    //self.song = [[AVPlayer alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self.tabBarController.tabBar setHidden:YES];
    // create autoScrollLabel
    self.autoScrollLabelTitle = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(10, 15, 320, 16)];
    [self.autoScrollLabelTitle setTextColor:[UIColor redColor]];
    self.autoScrollLabelArtist = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(10, 15, 320, 16)];
    [self.autoScrollLabelArtist setTextColor:[UIColor purpleColor]];
    self.autoScrollLabelComposer = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(10, 15, 320, 16)];
    [self.autoScrollLabelComposer setTextColor:[UIColor blueColor]];
    
    // Pan gesture recognizer
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePansGesture:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    [self.moveView addGestureRecognizer:panGesture];
    [self.viewNowPlaying addGestureRecognizer:panGesture];
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            [self.iVAvatar setHidden:NO];
            break;
        default:
            [self.iVAvatar setHidden:YES];
            break;
    }
}

// check width of device
- (BOOL) is320WidthDevice {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"%f - %f", screenWidth, screenHeight);
    return screenWidth <= 320;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.btnFavourite setImage:[UIImage imageNamed:@"likeYes"] forState:UIControlStateSelected];
    [self.btnShuffle setImage:[UIImage imageNamed:@"shuffleYes.png"] forState:UIControlStateSelected];
    [self.btnRepeat setImage:[UIImage imageNamed:@"repeatYes.png"] forState:UIControlStateSelected];
    [self.btnPause setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    [self.btnPauseBackground setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    
    [self.moveView setHidden:YES];
    [self playSong];
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.song.rate != 1.0f) {
        [self.btnPause setSelected:YES];
        [self.btnPauseBackground setSelected:YES];
        
        //[self.iVAvatar.layer removeAnimationForKey:@"Spin"];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.moveView setHidden:YES];
    
    //[[UIApplication sharedApplication].delegate.window addSubview:self.viewNowPlaying];
    //[self addConstraintForNowPlaying];
}

- (void) addConstraintForNowPlaying {
    [self.viewNowPlaying setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dicView = @{@"nowPlaying":self.viewNowPlaying};
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[nowPlaying]-0-|" options:0 metrics:nil views:dicView];
    [self.view addConstraints:horizontal];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nowPlaying(65)]-0-|" options:0 metrics:nil views:dicView];
    [self.view addConstraints:vertical];
}

// begin spin avatar
- (void) beginSpinAvatar {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 5.0;//Speed
    rotation.repeatCount = HUGE_VALF;//Repeat forever.
    [self.iVAvatar.layer addAnimation:rotation forKey:@"Spin"];
}

- (void) playSong {
    if ([self isConnected]) {
        // iD, title, artist, artistAvatar, composer, linkPlay
        NSArray *currentSong = [self.arraySong objectAtIndex:self.currentIndex];
        NSString *linkPlay128 = [currentSong objectAtIndex:5];
        NSURL *urlAudio = [NSURL URLWithString:linkPlay128];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:urlAudio];
        [self.song replaceCurrentItemWithPlayerItem:playerItem];
        [self.lbNo setText:[NSString stringWithFormat:@"%d/%d", self.currentIndex + 1, (int)self.arraySong.count]];
        NSString *title = [currentSong objectAtIndex:1];
        [self.navigationItem setTitle:title];NSString *artist = [currentSong objectAtIndex:2];
        [self.lbArtist setText:artist];
        
        NSString *composer = [currentSong objectAtIndex:4];
        [self.lbComposer setText:composer];
        
        NSString *avatar = [currentSong objectAtIndex:3];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *urlAvatar = [NSURL URLWithString:avatar];
            NSData *dataAvatar = [NSData dataWithContentsOfURL:urlAvatar];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.iVAvatar setImage:[UIImage imageWithData:dataAvatar]];
            });
        });
        
        [self beginSpinAvatar];
        
        Favourite *favourite = [self.coreDataHelper queryFavouriteWithID:[currentSong objectAtIndex:0]];
        if (favourite) {
            [self.btnFavourite setSelected:YES];
        } else {
            [self.btnFavourite setSelected:NO];
        }
        
        NSTimeInterval duration = CMTimeGetSeconds(self.song.currentItem.asset.duration);
        [self.lbTotal setText:[NSString stringWithFormat:@"%@", [self timeFormat:duration]]];
        
        if(self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
        //self.slider.minimumValue = 0;
        self.slider.maximumValue = CMTimeGetSeconds(self.song.currentItem.asset.duration);
        [self.song play];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        [alertView show];
        [self.iVAvatar.layer removeAnimationForKey:@"Spin"];
        [self.btnPause setSelected:YES];
        [self.btnPauseBackground setSelected:YES];
    }
}

// update slider value with song's current time
- (void) updateSliderValue {
    self.slider.value = CMTimeGetSeconds(self.song.currentTime);
    NSTimeInterval playTime = CMTimeGetSeconds([self.song currentTime]);
    NSTimeInterval duration = CMTimeGetSeconds(self.song.currentItem.asset.duration);
    float remain = duration - playTime;
    
    //NSLog(@"Played %d - Remain -%d  ",(int)playTime, (int)remain);
    [self.lbCurrent setText:[NSString stringWithFormat:@"%@", [self timeFormat:playTime]]];
    [self.lbRemain setText:[NSString stringWithFormat:@"-%@", [self timeFormat:remain]]];
    
    if(remain <= 1){
        if(self.timer) {
            [self.timer invalidate];
            self.timer = nil;
            
            // repeat condition
            if ([self.btnRepeat isSelected]) {
                [self playSong];
            } else if ([self.btnShuffle isSelected]) {
                [self handlingShuffle];
            } else {
                [self.song pause];
                [self.slider setValue:0 animated:YES];
                [self.btnPause setSelected:NO];
                [self.btnPauseBackground setSelected:YES];
                
                if (self.currentIndex < self.arraySong.count - 1) {
                    self.currentIndex += 1;
                } else {
                    self.currentIndex = 0;
                }
                [self playSong];;
            }
        }
    }
}

// action play song with current time following slider value
- (IBAction)sliderValueChanged:(id)sender {
//    if ([self isConnected]) {
    [self.song pause];
    NSTimeInterval playTime = CMTimeGetSeconds([self.song currentTime]);
    NSTimeInterval duration = CMTimeGetSeconds(self.song.currentItem.asset.duration);
    float remain = duration - playTime;
    
    [self.lbCurrent setText:[NSString stringWithFormat:@"%@", [self timeFormat:playTime]]];
    [self.lbRemain setText:[NSString stringWithFormat:@"-%@", [self timeFormat:remain]]];
    
    [self.song seekToTime:CMTimeMake(self.slider.value, 1)];
    if (self.btnPause.isSelected == NO) {
        [self.song play];
        [self.btnPause setSelected:NO];
        [self.btnPauseBackground setSelected:NO];
    }
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
//        [alertView show];
//    }
}

- (IBAction)btnPrevTouched:(id)sender {
    if ([self isConnected]) {
        [self.song pause];
        [self.btnPause setSelected:NO];
        [self.btnPauseBackground setSelected:NO];
        
        //[self.slider setValue:0 animated:YES];
        if (self.currentIndex > 0) {
            self.currentIndex -= 1;
        } else {
            self.currentIndex = (int)self.arraySong.count - 1;
        }
        [self playSong];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
}

- (IBAction)btnPauseTouched:(id)sender {
    [self.btnPause setSelected:!self.btnPause.isSelected];
//    [self.btnPauseBackground setSelected:!self.btnPauseBackground.isSelected];
    if (self.song.rate == 1.0f) {
        [self.song pause];
        [self.iVAvatar.layer removeAnimationForKey:@"Spin"];
        [self.btnPause setSelected:YES];
        [self.btnPauseBackground setSelected:YES];
    } else {
        if ([self isConnected]) {
            [self.song play];
            [self beginSpinAvatar];
            [self.btnPause setSelected:NO];
            [self.btnPauseBackground setSelected:NO];
        } else {
            
            [self.btnPause setSelected:YES];
            [self.btnPauseBackground setSelected:YES];
        }
    }
}

- (IBAction)btnStopTouched:(id)sender {
    [self.btnPause setSelected:YES];
    [self.btnPauseBackground setSelected:YES];
    [self.song pause];
    [self.slider setValue:0 animated:YES];
    [self.song seekToTime:CMTimeMake(self.slider.value, 1)];
    [self.iVAvatar.layer removeAnimationForKey:@"Spin"];
}

- (IBAction)btnNextTouched:(id)sender {
    if ([self isConnected]) {
        [self.song pause];
        [self.slider setValue:0 animated:YES];
        [self.btnPause setSelected:NO];
        [self.btnPauseBackground setSelected:NO];
        
        if (self.currentIndex < self.arraySong.count - 1) {
            self.currentIndex += 1;
        } else {
            self.currentIndex = 0;
        }
        [self playSong];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    
//    if ([self isConnected]) {
//        
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
//        [alertView show];
//    }
}

// action btnFavourite touched
- (IBAction)btnFavouriteTouched:(id)sender {
    NSArray *currentSong = [self.arraySong objectAtIndex:self.currentIndex];
    NSString *songID = [currentSong objectAtIndex:0];
    NSString *songTitle = [currentSong objectAtIndex:1];
    NSString *artist = [currentSong objectAtIndex:2];
    NSString *artistAvatar = [currentSong objectAtIndex:3];
    NSString *composer = [currentSong objectAtIndex:4];
    NSString *linkPlay128 = [currentSong objectAtIndex:5];
    if (self.btnFavourite.isSelected == NO) {
        Favourite *existFavourite = [self.coreDataHelper queryFavouriteWithID:songID];
        if (!existFavourite) {
            Favourite *favourite = [[Favourite alloc] initWithSongID:songID title:songTitle artist:artist artistAvatar:artistAvatar composer:composer linkPlay128:linkPlay128 managedObjectContext:self.managedObjectContext];
            [self.coreDataHelper saveContext];
            if (favourite) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You like this song" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
            }
        }
        
        
    } else {
        Favourite *favourite = [self.coreDataHelper queryFavouriteWithID:songID];
        if ([self.coreDataHelper deleteFavourite:favourite]) {
            [self.coreDataHelper saveContext];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You unlike this song" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            });
        }
    }
    
    [self.btnFavourite setSelected:!self.btnFavourite.isSelected];
    
}


// handling shuffle
- (void) handlingShuffle {
    [self.song pause];
    [self.slider setValue:0 animated:YES];
    [self.btnPause setSelected:NO];
    [self.btnPauseBackground setSelected:NO];
    int randomIndex = 0;
    
    do {
        randomIndex = arc4random() % self.arraySong.count;
    } while (randomIndex == self.currentIndex);
    
    self.currentIndex = randomIndex;
    [self playSong];
}

// format played time for UI function
- (NSString *)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = (int)lroundf(seconds);
    int roundedMinutes = (int)lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

// action btnShuffle touched
- (IBAction)btnShuffleTouched:(id)sender {
    [self.btnShuffle setSelected:!self.btnShuffle.isSelected];
    [self.btnRepeat setSelected:NO];
}

// action btnRepeat touched
- (IBAction)btnRepeatTouched:(id)sender {
    [self.btnRepeat setSelected:!self.btnRepeat.isSelected];
    [self.btnShuffle setSelected:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPrevBackgroundTouched:(id)sender {
    if ([self isConnected]) {
        [self.song pause];
        [self.btnPause setSelected:NO];
        [self.btnPauseBackground setSelected:NO];
        if (self.currentIndex > 0) {
            self.currentIndex -= 1;
        } else {
            self.currentIndex = (int)self.arraySong.count - 1;
        }
        [self playSong];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    
}


- (IBAction)btnPauseBackgroundTouched:(id)sender {
    [self.btnPause setSelected:!self.btnPause.isSelected];
    [self.btnPauseBackground setSelected:!self.btnPauseBackground.isSelected];
    if (self.song.rate == 1.0f) {
        [self.song pause];
        [self.iVAvatar.layer removeAnimationForKey:@"Spin"];
    } else {
        [self.song play];
        [self beginSpinAvatar];
    }
}
- (IBAction)btnNextBackgroundTouched:(id)sender {
    if ([self isConnected]) {
        [self.song pause];
        [self.slider setValue:0 animated:YES];
        [self.btnPause setSelected:NO];
        [self.btnPauseBackground setSelected:NO];
        
        if (self.currentIndex < self.arraySong.count - 1) {
            self.currentIndex += 1;
        } else {
            self.currentIndex = 0;
        }
        [self playSong];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)handlePansGesture:(UIPanGestureRecognizer *)paramGesture {
    UIView *view = paramGesture.view;
    CGPoint currentTouch = [paramGesture locationInView:self.view];
    if (view == self.moveView) {
        if (paramGesture.state == UIGestureRecognizerStateBegan) {
            touchedPoint = CGPointMake(view.center.x - currentTouch.x,view.center.y - currentTouch.y);
        } else if (paramGesture.state != UIGestureRecognizerStateCancelled && paramGesture.state != UIGestureRecognizerStateFailed) {
            view.center = CGPointMake(currentTouch.x + touchedPoint.x, currentTouch.y + touchedPoint.y);
        }
    }
}

- (BOOL) isConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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
