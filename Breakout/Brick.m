//
//  Brick.m
//  Breakout
//
//  Created by mac on 8/1/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import "Brick.h"

@implementation Brick

- (void) addScore: (int) score {
    _score = score;
    switch (score) {
        case 0:
            //self.score = 0;
            self.hidden = true;
            break;
        case 1:
            //self.score = 1;
            //self.backgroundColor = [UIColor redColor];
            self.backgroundColor = [[UIColor alloc] initWithHex:@"E53935" alpha:1.0];
            break;
            
        case 2:
            //self.score = 2;
            //self.backgroundColor = [UIColor yellowColor];
            self.backgroundColor = [[UIColor alloc] initWithHex:@"FFFF00" alpha:1.0];
            break;
            
        case 3:
            //self.score = 3;
            //self.backgroundColor = [UIColor blueColor];
            self.backgroundColor = [[UIColor alloc] initWithHex:@"1976D2" alpha:1.0];
            break;
            
        
            
        default:
            NSLog(@"add score : %d", score);
            break;
    }
    
    //return self;
}

- (void) setScore:(int)score
{
    _score = score;
    switch (_score) {
        case 1:
            self.backgroundColor = [[UIColor alloc] initWithHex:@"E53935" alpha:1.0];
            break;
            
        case 2:
            self.backgroundColor = [[UIColor alloc] initWithHex:@"FFFF00" alpha:1.0];
            break;
            
        case 3:
            self.backgroundColor = [[UIColor alloc] initWithHex:@"1976D2" alpha:1.0];
            break;
            
        default:
            [self setHidden:YES];
            //[self removeFromSuperview];
            NSLog(@"add score : %d", _score);
            //break;
    }

}

- (instancetype) initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}
@end
