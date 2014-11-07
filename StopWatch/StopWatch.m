//
//  StopWatch.m
//
//  Created by René Rössler on 18.06.13.
//  Copyright (c) 2013 FreshX GbR. All rights reserved.
//

#import "StopWatch.h"
#import <BButton/BButton.h>

@interface StopWatch()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, strong) NSDateFormatter* dateFormatter;
@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) BButton* toggleButton;
@property (nonatomic, strong) BButton* resetButton;

@end

@implementation StopWatch

#pragma mark - init

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
    
    self.toggleButton = [BButton awesomeButtonWithOnlyIcon:FAPlay type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    [self.toggleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.toggleButton];
    
    self.resetButton = [BButton awesomeButtonWithOnlyIcon:FATimes color:[UIColor redColor] style:BButtonStyleBootstrapV3];
    [self.resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    self.showResetButton = YES;
    
    self.target = nil;
    self.action = nil;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0.0];
    self.startDate = nil;
    self.timer = nil;
    self.showMilliseconds = NO;
    [self reset];
}

#pragma mark - properties

-(void)setTime:(NSTimeInterval)time {
    if (time != _time) {
        _time = time;
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    self.label.text = [self.dateFormatter stringFromDate:date];
}

-(void)setShowMilliseconds:(BOOL)showMilliseconds {
    if (showMilliseconds == YES) {
        self.dateFormatter.dateFormat = @"HH:mm:ss.SSS";
    } else {
        self.dateFormatter.dateFormat = @"HH:mm:ss";
    }
    
    
    if (showMilliseconds != _showMilliseconds) {
        _showMilliseconds = showMilliseconds;
        
        self.time = self.time;
    }
}

-(BOOL)running {
    return (self.timer != nil);
}

-(void)setShowResetButton:(BOOL)showResetButton {
    _showResetButton = showResetButton;
    
    if (showResetButton == YES && self.resetButton.superview == nil) {
        [self addSubview:self.resetButton];
    } else if (showResetButton == NO && self.resetButton.superview != nil) {
        [self.resetButton removeFromSuperview];
    }
}

-(void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        self.toggleButton.enabled = enabled;
        self.resetButton.enabled = enabled;
    }
}

#pragma mark - update

-(void)update {
    NSDate* now = [NSDate date];
    NSTimeInterval offset = [now timeIntervalSinceDate:self.startDate];
    self.startDate = now;
    self.time = self.time + offset;
    
    if (self.target != nil && self.action != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
    }
}

#pragma mark - layout

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth=60;
    if (self.showResetButton == YES) {
        self.resetButton.frame = CGRectMake(self.bounds.size.width-buttonWidth,0,buttonWidth,self.bounds.size.height);
        self.toggleButton.frame = CGRectMake(self.bounds.size.width-buttonWidth-buttonWidth-5,0,buttonWidth,self.bounds.size.height);
        self.label.frame = CGRectMake(0,0,self.bounds.size.width-buttonWidth-buttonWidth-10,self.bounds.size.height);
    } else {
        self.toggleButton.frame = CGRectMake(self.bounds.size.width-buttonWidth,0,buttonWidth,self.bounds.size.height);
        self.label.frame = CGRectMake(0,0,self.bounds.size.width-buttonWidth-5,self.bounds.size.height);
    }
}

#pragma mark - target

-(void)setTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}

#pragma mark - action

-(void)start {
    if (self.running == NO) {
        self.startDate = [NSDate date];
        
        NSTimeInterval timerInterval = 0.1;
        if (self.showMilliseconds == YES) {
            timerInterval = 0.001;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
}

-(void)stop {
    if (self.running == YES) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)toggle {
    if (self.running == YES) {
        [self stop];
    } else {
        [self start];
    }
    
    [self.toggleButton removeFromSuperview];
    if (self.running == YES) {
        self.toggleButton = [BButton awesomeButtonWithOnlyIcon:FAPause type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    } else {
        self.toggleButton = [BButton awesomeButtonWithOnlyIcon:FAPlay type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    }
    [self.toggleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.toggleButton];
}

-(void)reset {
    self.time = 0;
}

@end
