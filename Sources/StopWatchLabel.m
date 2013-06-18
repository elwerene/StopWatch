//
//  StopWatchLabel.m
//
//  Created by René Rössler on 18.06.13.
//  Copyright (c) 2013 FreshX GbR. All rights reserved.
//

#import "StopWatchLabel.h"

@interface StopWatchLabel() {
    NSDateFormatter* dateFormatter;
    NSDate* startDate;
    NSTimer* timer;
}
@end

@implementation StopWatchLabel

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
    self.text = [dateFormatter stringFromDate:date];
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

#pragma mark - update

-(void)update {
    NSDate* now = [NSDate date];
    NSTimeInterval offset = [now timeIntervalSinceDate:startDate];
    startDate = now;
    self.time = self.time + offset;
}

#pragma mark - actions

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
}

-(void)reset {
    self.time = 0;
}

@end
