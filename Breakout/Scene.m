//
//  Scene.m
//  MarioInCity
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import "Scene.h"

@implementation Scene

- (void) loadView {
    [super loadView];
    self.sprites = [NSMutableDictionary new];
}

- (void) addSprite: (Sprite*) sprite {
    [self.sprites setObject: sprite
                     forKey: sprite.name];
    [self.view addSubview: sprite.view];
}

- (void) removeSprite: (Sprite*) sprite {
    [self.sprites removeObjectForKey:sprite.name];
    [sprite.view removeFromSuperview];
}

- (void) removeSpriteByName:(NSString *)spriteName {
    UIView* removeView = self.sprites[spriteName];
    [removeView removeFromSuperview];
    [self.sprites removeObjectForKey:spriteName];
}

@end
