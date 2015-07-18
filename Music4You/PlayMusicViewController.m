//
//  PlayMusicViewController.m
//  Music4You
//
//  Created by Peter Pike on 7/14/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "PlayMusicViewController.h"

@interface PlayMusicViewController ()

@property (strong, nonatomic) CoreDataHelper *coreDataHelper;

@property (weak, nonatomic) IBOutlet UIButton *btnFavourite;

@property (weak, nonatomic) IBOutlet UIImageView *iVAvatar;

@property (strong, nonatomic) AutoScrollLabel *autoScrollLabelTitle;
@property (strong, nonatomic) AutoScrollLabel *autoScrollLabelArtist;
@property (strong, nonatomic) AutoScrollLabel *autoScrollLabelComposer;
@property (weak, nonatomic) IBOutlet UILabel *lbArtist;
@property (weak, nonatomic) IBOutlet UILabel *lbComposer;

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
    
    self.coreDataHelper = [[CoreDataHelper alloc] init];
    self.managedObjectContext = [self managedObjectContext];
    self.coreDataHelper.context = self.managedObjectContext;
    
    self.iVAvatar.layer.cornerRadius = 82;
    self.iVAvatar.layer.masksToBounds = YES;
    
    self.song = ((AppDelegate *)([UIApplication sharedApplication].delegate)).song;
    //self.isPlayingSongSelected = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self.tabBarController.tabBar setHidden:YES];
    // create autoScrollLabel
    self.autoScrollLabelTitle = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(10, 15, 320, 16)];
    [self.autoScrollLabelTitle setTextColor:[UIColor redColor]];
    self.autoScrollLabelArtist = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(10, 15, 320, 16)];
    [self.autoScrollLabelArtist setTextColor:[UIColor purpleColor]];
    self.autoScrollLabelComposer = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(10, 15, 320, 16)];
    [self.autoScrollLabelComposer setTextColor:[UIColor blueColor]];
    
    
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
    //self.song = [[AVPlayer alloc] init];
    [self.lbArtist setText:@" "];
    [self.lbComposer setText:@" "];
    [self.btnFavourite setImage:[UIImage imageNamed:@"likeYes"] forState:UIControlStateSelected];
    [self.btnShuffle setImage:[UIImage imageNamed:@"shuffleYes.png"] forState:UIControlStateSelected];
    [self.btnRepeat setImage:[UIImage imageNamed:@"repeatYes.png"] forState:UIControlStateSelected];
    [self.btnPause setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    
    
    [self playSong];
}

// begin spin avatar
- (void) beginSpinAvatar {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 5.0;// Speed
    rotation.repeatCount = HUGE_VALF;// Repeat forever.
    [self.iVAvatar.layer addAnimation:rotation forKey:@"Spin"];
}

- (void) playSong {
    // iD, title, artist, artistAvatar, composer, linkPlay
    
    NSArray *currentSong = [self.arraySong objectAtIndex:self.currentIndex];
    NSString *linkPlay128 = [currentSong objectAtIndex:5];
    NSURL *urlAudio = [NSURL URLWithString:linkPlay128];
    //self.song = [AVPlayer playerWithURL:urlAudio];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:urlAudio];
    [self.song replaceCurrentItemWithPlayerItem:playerItem];
    //self.song = [[AVPlayer alloc] initWithURL:urlAudio];
    [self.song play];
    
    NSString *title = [currentSong objectAtIndex:1];
    [self.navigationItem setTitle:title];
    
    //[self.autoScrollLabelTitle setText:title];
    NSString *artist = [currentSong objectAtIndex:2];
    [self.lbArtist setText:artist];
    //[self.autoScrollLabelArtist setText:artist];
    NSString *composer = [currentSong objectAtIndex:4];
    [self.lbComposer setText:composer];
    //[self.autoScrollLabelComposer setText:composer];
    
    //[self.navigationController.navigationBar addSubview:self.autoScrollLabelTitle];
    //[self.lbArtist addSubview:self.autoScrollLabelArtist];
    //[self.lbComposer addSubview:self.autoScrollLabelComposer];
    
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
                //[self btnStopTouched:self];
                [self playSong];
            } else if ([self.btnShuffle isSelected]) {
                [self handlingShuffle];
            } else {
                [self btnNextTouched:self];
            }
        }
    }
}

// action play song with current time following slider value
- (IBAction)sliderValueChanged:(id)sender {
    [self.song pause];
    //self.song.currentTime = self.slider.value;
    
    
    NSTimeInterval playTime = CMTimeGetSeconds([self.song currentTime]);
    NSTimeInterval duration = CMTimeGetSeconds(self.song.currentItem.asset.duration);
    float remain = duration - playTime;
    
    [self.lbCurrent setText:[NSString stringWithFormat:@"%@", [self timeFormat:playTime]]];
    [self.lbRemain setText:[NSString stringWithFormat:@"-%@", [self timeFormat:remain]]];
    
    [self.song seekToTime:CMTimeMake(self.slider.value, 1)];
    if (self.btnPause.isSelected == NO) {
        [self.song play];
        [self.btnPause setSelected:NO];
    }
    
}

- (IBAction)btnPrevTouched:(id)sender {
    [self.song pause];
    [self.btnPause setSelected:NO];
    //[self.slider setValue:0 animated:YES];
    if (self.currentIndex > 0) {
        self.currentIndex -= 1;
    } else {
        self.currentIndex = (int)self.arraySong.count - 1;
    }
    [self playSong];
}

- (IBAction)btnPauseTouched:(id)sender {
    [self.btnPause setSelected:!self.btnPause.isSelected];
    if (self.song.rate == 1.0f) {
        [self.song pause];
        [self.iVAvatar.layer removeAnimationForKey:@"Spin"];
    } else {
        [self.song play];
        [self beginSpinAvatar];
    }
}

- (IBAction)btnStopTouched:(id)sender {
    [self.btnPause setSelected:YES];
    [self.song pause];
    [self.slider setValue:0 animated:YES];
    [self.song seekToTime:CMTimeMake(self.slider.value, 1)];
    [self.iVAvatar.layer removeAnimationForKey:@"Spin"];
}

- (IBAction)btnNextTouched:(id)sender {
    [self.song pause];
    [self.slider setValue:0 animated:YES];
    [self.btnPause setSelected:NO];
    
    if (self.currentIndex < self.arraySong.count - 1) {
        self.currentIndex += 1;
    } else {
        self.currentIndex = 0;
    }
    [self playSong];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
