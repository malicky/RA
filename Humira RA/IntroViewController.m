//
//  IntroViewController.m
//  crohns
//
//  Created by Developer on 12-02-13.
//  Copyright (c) 2012 . All rights reserved.
//

#import "IntroViewController.h"

@implementation IntroViewController
@synthesize playerView;
@synthesize mplayer = _mplayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //load video
    NSString *filename = @"intro.mp4";
    NSString *extension = [filename pathExtension];
    NSString *name = [filename stringByDeletingPathExtension];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:extension];
    
    if (self.mplayer) {
        [self.mplayer stop];
    }
    
    self.mplayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    self.mplayer.scalingMode = MPMovieScalingModeAspectFit;
    self.mplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mplayer.controlStyle = MPMovieControlStyleNone;
    self.mplayer.view.frame = self.playerView.bounds;
    [self.playerView addSubview:self.mplayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.mplayer];
    
    [self.mplayer play];
}

- (void)viewDidUnload
{
    [self setPlayerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)playbackDidFinish:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.mplayer];
    [self performSegueWithIdentifier:@"MainSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.mplayer stop];
}

@end
