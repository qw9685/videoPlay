//
//  localPlayerViewController.m
//  视频播放(网络+本地)
//
//  Created by mac on 2019/11/23.
//  Copyright © 2019 cc. All rights reserved.
//

#import "localPlayerViewController.h"
#import <AVKit/AVKit.h>

// 屏幕尺寸
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface localPlayerViewController (){
    BOOL isPlay;
}

@property (nonatomic,strong) UIView *playerView;//显示的播放层
@property (nonatomic,strong) AVPlayer *avplayer;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) NSTimer* timer;//播放进度
@property (nonatomic,strong) UITapGestureRecognizer *playControllerGes;//播放暂停

@end

@implementation localPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPlayer:[[NSBundle mainBundle] pathForResource:@"0.mp4" ofType:nil]];
    //总时长
    NSTimeInterval totalTime = CMTimeGetSeconds(self.avplayer.currentItem.asset.duration);
    self.slider.minimumValue = 0;
    self.slider.maximumValue = totalTime;
    
    //播放完成监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //监听拖拽
    [self.slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerView addGestureRecognizer:self.playControllerGes];
    [self.view addSubview:self.playerView];
    [self.playerView addSubview:self.slider];
    
}

- (void)initPlayer:(NSString*)path{
    AVPlayerItem *avplayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:path]];
    self.avplayer = [AVPlayer playerWithPlayerItem:avplayerItem];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    layer.frame = self.playerView.bounds;
    [self.playerView.layer addSublayer:layer];
}

- (void)ges{
    if (isPlay) {
        [self pause];
    }else{
        [self play];
    }
}

- (void)repeatShowTime:(NSTimer *)tempTimer {
    //当前时间进度
    NSTimeInterval currentTime = CMTimeGetSeconds(self.avplayer.currentTime);
    [self.slider setValue:currentTime];
}

- (void)videoPlayEnd{
    CMTime changedTime = CMTimeMakeWithSeconds(0, 1.0);
    self.slider.value = 0;
    [self.avplayer seekToTime:changedTime completionHandler:^(BOOL finished) {
        [self pause];
    }];
}

- (void)sliderTouchDown:(UISlider*)slider{
    [self pause];
}
- (void)sliderTouchInside:(UISlider*)slider{
    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1.0);
    [self.avplayer seekToTime:changedTime completionHandler:^(BOOL finished) {
        [self play];
    }];
}

- (void)pause{
    [self.avplayer pause];
    [self timerPause];
    isPlay = NO;
}

- (void)play{
    [self.avplayer play];
    [self timerPlay];
    isPlay = YES;
}

- (void)timerPlay{
    [self.timer setFireDate:[NSDate date]];
}

- (void)timerPause{
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark ------------------------- set&get -------------------------
-(UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 300)];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}

-(UITapGestureRecognizer *)playControllerGes{
    if (!_playControllerGes) {
        _playControllerGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ges)];
    }
    return _playControllerGes;
}
-(UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, self.playerView.frame.size.height - 4, kScreenWidth, 4)];
    }
    return _slider;
}
-(NSTimer *)timer{
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(repeatShowTime:) userInfo:nil repeats:YES];
        
    }
    return _timer;
}

@end
