//
//  Controller.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-11-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Role.h"

@interface Controller : NSObject {
    
}

-(BOOL) ccKeyDown:(NSEvent *)event withSprite:(Role*)spr
     withTiledMap:(TileMap *)map spritebodys:(CCArray*)bodys;

-(BOOL) ccKeyUp:(NSEvent *)event withSprite:(Role*)spr
   withTiledMap:(TileMap *)map spritebodys:(CCArray*)bodys;

@end
