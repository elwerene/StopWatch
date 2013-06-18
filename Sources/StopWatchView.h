//
//  StopWatchView.h
//
//  Created by René Rössler on 18.06.13.
//  Copyright (c) 2013 FreshX GbR. All rights reserved.
//

#import <UIKit/UIView.h>
@class StopWatchLabel;

@interface StopWatchView : UIView

@property (nonatomic, readonly) StopWatchLabel* label;
@property (nonatomic, assign) BOOL showResetButton;

//from label
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) BOOL showMilliseconds;

@end
