//
//  StopWatchLabel.h
//
//  Created by René Rössler on 18.06.13.
//  Copyright (c) 2013 FreshX GbR. All rights reserved.
//

#import <UIKit/UILabel.h>

@interface StopWatchLabel : UILabel

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) BOOL showMilliseconds;
@property (nonatomic, readonly) BOOL running;

-(void)start;
-(void)stop;
-(void)toggle;
-(void)reset;

@end
