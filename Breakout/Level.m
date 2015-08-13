//
//  Level.m
//  Breakout
//
//  Created by mac on 8/1/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import "Level.h"

@implementation Level


- (instancetype) initWithCols: (NSInteger) cols
                      andRows: (NSInteger) rows
                       andMap: (NSMutableArray *) map {
    
    
    self = [super init];
    if (self) {
        self.columns = cols;
        self.rows = rows;
        
        if (map.count != cols * rows) {
            self.map = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < cols * rows; i++) {
                [self.map addObject:(@(1 + (NSInteger)arc4random_uniform(3)))];
            }
            
        } else {
            self.map = map;
        }

    }
    return self;
}
@end
