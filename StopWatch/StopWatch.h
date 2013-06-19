//
//  StopWatch.h
//
//  Created by René Rössler on 18.06.13.
//  Copyright (c) 2013 FreshX GbR. All rights reserved.
//

#import <UIKit/UIView.h>

@interface StopWatch : UIView

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) BOOL showResetButton;
@property (nonatomic, assign) BOOL showMilliseconds;
@property (nonatomic, readonly) BOOL running;

-(void)setTarget:(id)target action:(SEL)action;

-(void)start;
-(void)stop;
-(void)toggle;
-(void)reset;

@end
