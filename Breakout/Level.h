//
//  Level.h
//  Breakout
//
//  Created by mac on 8/1/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic, strong) NSMutableArray *map;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) NSInteger rows;

- (instancetype) initWithCols: (NSInteger) cols
                      andRows: (NSInteger) rows
                      andMap: (NSArray *) map ;
@end
