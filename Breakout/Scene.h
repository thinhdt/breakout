//
//  Scene.h
//  MarioInCity
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sprite.h"

@class Sprite;

@interface Scene : UIViewController

@property (nonatomic, strong) NSMutableDictionary *sprites;
@property(nonatomic, assign) CGSize size;

- (void) addSprite: (Sprite*) sprite;

- (void) removeSprite: (Sprite*) sprite;

- (void) removeSpriteByName: (NSString*) spriteName;

@end
