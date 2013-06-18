//
//  StopWatchView.m
//
//  Created by René Rössler on 18.06.13.
//  Copyright (c) 2013 FreshX GbR. All rights reserved.
//

#import "StopWatchView.h"
#import "StopWatchLabel.h"
#import <BButton/BButton.h>

@interface StopWatchView() {
    StopWatchLabel* _label;
    BButton* toggleButton;
    BButton* resetButton;
}

@end

@implementation StopWatchView

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
    _label = [[StopWatchLabel alloc] init];
    [self addSubview:_label];
    
    toggleButton = [BButton awesomeButtonWithOnlyIcon:FAIconPlay type:BButtonTypeDefault];
    [toggleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:toggleButton];
    
    resetButton = [BButton awesomeButtonWithOnlyIcon:FAIconRemoveSign color:[UIColor redColor]];
    [resetButton addTarget:self.label action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    self.showResetButton = YES;
}

#pragma mark - properties

-(void)setShowResetButton:(BOOL)showResetButton {
    _showResetButton = showResetButton;
    
    if (showResetButton == YES && resetButton.superview == nil) {
        [self addSubview:resetButton];
    } else if (showResetButton == NO && resetButton.superview != nil) {
        [resetButton removeFromSuperview];
    }
}

-(void)setShowMilliseconds:(BOOL)showMilliseconds {
    self.label.showMilliseconds = showMilliseconds;
}
-(BOOL)isShowMilliseconds {
    return self.label.showMilliseconds;
}

-(void)setTime:(NSTimeInterval)time {
    self.label.time = time;
}
-(NSTimeInterval)time {
    return self.label.time;
}

#pragma mark - layout

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth=60;
    if (self.showResetButton == YES) {
        resetButton.frame = CGRectMake(self.bounds.size.width-buttonWidth,0,buttonWidth,self.bounds.size.height);
        toggleButton.frame = CGRectMake(self.bounds.size.width-buttonWidth-buttonWidth-5,0,buttonWidth,self.bounds.size.height);
        self.label.frame = CGRectMake(0,0,self.bounds.size.width-buttonWidth-buttonWidth-10,self.bounds.size.height);
    } else {
        toggleButton.frame = CGRectMake(self.bounds.size.width-buttonWidth,0,buttonWidth,self.bounds.size.height);
        self.label.frame = CGRectMake(0,0,self.bounds.size.width-buttonWidth-5,self.bounds.size.height);
    }
}

#pragma mark - action

-(void)toggle {
    [self.label toggle];
    
    [toggleButton removeFromSuperview];
    if (self.label.running == YES) {
        toggleButton = [BButton awesomeButtonWithOnlyIcon:FAIconPause type:BButtonTypeDefault];
    } else {
        toggleButton = [BButton awesomeButtonWithOnlyIcon:FAIconPlay type:BButtonTypeDefault];
    }
    [toggleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:toggleButton];
}

@end
