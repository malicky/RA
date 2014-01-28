//
//  IntroViewController.h
//  crohns
//
//  Created by Developer on 12-02-13.
//  Copyright (c) 2012 . All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface IntroViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) MPMoviePlayerController *mplayer;

@end
