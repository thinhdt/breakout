//
//  Brick.h
//  Breakout
//
//  Created by mac on 8/1/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extend.h"

@interface Brick : UIView
@property (nonatomic) int score;
- (void) addScore: (int) score;
- (void) CaluScore;
@end
