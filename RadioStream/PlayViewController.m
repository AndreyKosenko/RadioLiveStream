//
//  PlayViewController.m
//  RadioStream
//
//  Created by dev on 3/7/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "PlayViewController.h"
#import "AudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import <MBProgressHUD/MBProgressHUD.h>
BOOL isPlay;
float currentVolume;
@interface PlayViewController ()

@property (strong, nonatomic) IBOutlet UIButton *buttonPlay;
@property (strong, nonatomic) IBOutlet UISlider *objSlider;
@property (strong, nonatomic) IBOutlet UIImageView *objVolumeBarImg;

@property (strong, nonatomic) MBProgressHUD *loader;

@end
    NSString *streamPath;
@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPlay = false;
    currentVolume = 1.0;
    [self OnSlideChangedValue:nil];
    // Do any additional setup after loading the view.

    //streamPath = @"http://transom.org/sounds/2004/tools/200403_mp3/stereo_96kbps.mp3";
    //streamPath = @"http://uk1.internet-radio.com:8174/live";
    streamPath = @"http://icecast.radio24.ch/radio24pop";
    
    [self createStreamer:streamPath ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPlay:(id)sender {
    if (isPlay == true) {
        [streamer stop];
        NSLog(@"stop");
    }else{
        
        [self.view endEditing:YES];
        self.loader = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        self.loader.mode = MBProgressHUDModeAnnularDeterminate;
        self.loader.labelText = @"Please wait.";
        
        self.loader.labelFont = [UIFont fontWithName:@"Bariol-Bold" size:[UIFont systemFontSize]];
        
        //self.loader.detailsLabelText = @"Just relax";
        [self.loader showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
        
        [self createStreamer:streamPath];
        [streamer start];
        NSLog(@"start");
    }
}
- (void)doSomeFunkyStuff {
    float progress = 0.0;
    
    while (progress < 1.00) {
        progress += 0.01;
        self.loader.progress = progress;
        if(isPlay) break;
        usleep(200000);
    }
    if (!isPlay) {
        [streamer stop];
    }
}

- (IBAction)OnSlideChangedValue:(id)sender {
    UIImage *VolumeImage;
    if (self.objSlider.value >= 0.1f && self.objSlider.value <= 0.25f) {
       VolumeImage = [UIImage imageNamed:@"VolumeBar1.png"];
    }else if (self.objSlider.value > 0.25f && self.objSlider.value <= 0.50f) {
        VolumeImage = [UIImage imageNamed:@"VolumeBar2.png"];
    }else if (self.objSlider.value > 0.50f && self.objSlider.value <= 0.75f) {
        VolumeImage = [UIImage imageNamed:@"VolumeBar3.png"];
    }else if (self.objSlider.value > 0.75f && self.objSlider.value <= 1.0f) {
        VolumeImage = [UIImage imageNamed:@"VolumeBar4.png"];
    }else{
        VolumeImage = [UIImage imageNamed:@"VolumeBar0.png"];
    }
    self.objVolumeBarImg.image = VolumeImage;
    if (isPlay && (fabs(self.objSlider.value - currentVolume) > 0.10)) {
        [streamer changeVolume: self.objSlider.value];
        currentVolume = self.objSlider.value;
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

///////////////////////
//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
    if (streamer)
    {
        
        /*
         [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
         */
        
        
        /*
         [progressUpdateTimer invalidate];
         progressUpdateTimer = nil;
         */
        [streamer stop];
  //      [streamer release];
        streamer = nil;
    }
}
//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer:(NSString*)urlin
{
    
    [self destroyStreamer];
    
    NSString *escapedValue =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)urlin,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8))
     ;
    
    NSURL *url = [NSURL URLWithString:escapedValue];
    streamer = [[AudioStreamer alloc] initWithURL:url];
    /*[streamer
     addObserver:self
     forKeyPath:@"isPlaying"
     options:0
     context:nil];
     */
    streamer.delegate = self;
    
    
    /*
     [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
     */
}


//- (void)setNowPlaying:(CDVInvokedUrlCommand *)command
//{
//    if (NSClassFromString(@"MPNowPlayingInfoCenter"))  {
//        /* we're on iOS 5, so set up the now playing center */
//        NSString  *title      =  [command.arguments objectAtIndex:0];
//        NSString  *station      =  [command.arguments objectAtIndex:1];
//        
//        NSDictionary *currentlyPlayingTrackInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:title, station, nil] forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyTitle, MPMediaItemPropertyAlbumTitle, nil]];
//        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentlyPlayingTrackInfo;
//    }
//    
//}


- (void)metaDataUpdated:(NSString *)metaData
{
    
    NSArray *listItems = [metaData componentsSeparatedByString:@";"];
    
    NSString *metadata;
    
    if ([listItems count] > 0) {
        metadata = [listItems objectAtIndex:0];
    }
    
    metadata = [metadata stringByReplacingOccurrencesOfString:@"'" withString:@"\\\'"];
    
//    NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.AudioStream.setMetaData(' %@ ')",  metadata];
//    [self writeJavascript:jsCallBack];
    
}

- (void)statusChanged:(NSString *)status;
{
    
//    NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.AudioStream.setStatus( '%@')",  status];
//    [self writeJavascript:jsCallBack];
    
    NSLog(status);
    if ([status isEqualToString:@"isPlaying"]) {
        UIImage *btnImage = [UIImage imageNamed:@"ButtonStop_Icon.png"];
        [self.buttonPlay setBackgroundImage:btnImage forState:UIControlStateNormal];
        isPlay = true;
        [self.loader hide:YES];
        [streamer changeVolume: currentVolume];
    }else if([status isEqualToString:@"isStopping"]){
        UIImage *btnImage = [UIImage imageNamed:@"ButtonPlay_Icon.png"];
        [self.buttonPlay setBackgroundImage:btnImage forState:UIControlStateNormal];
        isPlay = false;
    }else{
        [self.loader hide:YES];
    }

}


- (void)streamError
{
    NSLog(@"Stream Error.");
    UIImage *btnImage = [UIImage imageNamed:@"ButtonPlay_Icon.png"];
    [self.buttonPlay setBackgroundImage:btnImage forState:UIControlStateNormal];
    isPlay = false;
    [self.loader hide:YES];
}


// Called when an error happens - defaults to: @selector(streamError:)
- (void)audioStreamerError{
    NSLog(@"audio stream Error.");
    UIImage *btnImage = [UIImage imageNamed:@"ButtonPlay_Icon.png"];
    [self.buttonPlay setBackgroundImage:btnImage forState:UIControlStateNormal];
    isPlay = false;
    [self.loader hide:YES];
}

// Called when we receive a 302 redirect to another url
- (void)redirectStreamError:(NSURL*)redirectURL{
    NSLog(@"redirect stream Error.");
}

// Called when we detect the bitrate
- (void)updateBitrate:(uint32_t)br{
    NSLog(@"update bitrate Error.");
}


@end
