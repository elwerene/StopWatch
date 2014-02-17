//
//  StopWatch.m
//
//  Created by René Rössler on 18.06.13.
//  Copyright (c) 2013 FreshX GbR. All rights reserved.
//

#import "StopWatch.h"
#import <BButton/BButton.h>

@interface StopWatch() {
    NSDateFormatter* dateFormatter;
    NSDate* startDate;
    NSTimer* timer;
    UILabel* label;
    BButton* toggleButton;
    BButton* resetButton;
}

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

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
    label = [[UILabel alloc] init];
    [self addSubview:label];
    
    toggleButton = [BButton awesomeButtonWithOnlyIcon:FAIconPlay type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    [toggleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:toggleButton];
    
    resetButton = [BButton awesomeButtonWithOnlyIcon:FAIconRemoveSign color:[UIColor redColor] style:BButtonStyleBootstrapV3];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    self.showResetButton = YES;
    
    self.target = nil;
    self.action = nil;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0.0];
    startDate = nil;
    timer = nil;
    self.showMilliseconds = NO;
    [self reset];
}

#pragma mark - properties

-(void)setTime:(NSTimeInterval)time {
    if (time != _time) {
        _time = time;
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    label.text = [dateFormatter stringFromDate:date];
}

-(void)setShowMilliseconds:(BOOL)showMilliseconds {
    if (showMilliseconds == YES) {
        dateFormatter.dateFormat = @"HH:mm:ss.SSS";
    } else {
        dateFormatter.dateFormat = @"HH:mm:ss";
    }
    
    
    if (showMilliseconds != _showMilliseconds) {
        _showMilliseconds = showMilliseconds;
        
        self.time = self.time;
    }
}

-(BOOL)running {
    return (timer != nil);
}

-(void)setShowResetButton:(BOOL)showResetButton {
    _showResetButton = showResetButton;
    
    if (showResetButton == YES && resetButton.superview == nil) {
        [self addSubview:resetButton];
    } else if (showResetButton == NO && resetButton.superview != nil) {
        [resetButton removeFromSuperview];
    }
}

-(void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        toggleButton.enabled = enabled;
        resetButton.enabled = enabled;
    }
}

#pragma mark - update

-(void)update {
    NSDate* now = [NSDate date];
    NSTimeInterval offset = [now timeIntervalSinceDate:startDate];
    startDate = now;
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
        resetButton.frame = CGRectMake(self.bounds.size.width-buttonWidth,0,buttonWidth,self.bounds.size.height);
        toggleButton.frame = CGRectMake(self.bounds.size.width-buttonWidth-buttonWidth-5,0,buttonWidth,self.bounds.size.height);
        label.frame = CGRectMake(0,0,self.bounds.size.width-buttonWidth-buttonWidth-10,self.bounds.size.height);
    } else {
        toggleButton.frame = CGRectMake(self.bounds.size.width-buttonWidth,0,buttonWidth,self.bounds.size.height);
        label.frame = CGRectMake(0,0,self.bounds.size.width-buttonWidth-5,self.bounds.size.height);
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
        startDate = [NSDate date];
        
        NSTimeInterval timerInterval = 0.1;
        if (self.showMilliseconds == YES) {
            timerInterval = 0.001;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
}

-(void)stop {
    if (self.running == YES) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)toggle {
    if (self.running == YES) {
        [self stop];
    } else {
        [self start];
    }
    
    [toggleButton removeFromSuperview];
    if (self.running == YES) {
        toggleButton = [BButton awesomeButtonWithOnlyIcon:FAIconPause type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    } else {
        toggleButton = [BButton awesomeButtonWithOnlyIcon:FAIconPlay type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    }
    [toggleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:toggleButton];
}

-(void)reset {
    self.time = 0;
}

@end
