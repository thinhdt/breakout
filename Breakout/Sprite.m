//
//  Sprite.m
//  MarioInCity
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

- (instancetype) initWithName: (NSString*) name
                      ownView: (UIView*) view
                      inScene: (Scene*) scene {
    if (self = [super init]) {
        self.name = name;
        self.view = view;
        self.scene = scene;
    }
    return self;
}

@end
