//
//  Controller.m
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-11-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"

@implementation Controller

-(BOOL) ccKeyDown:(NSEvent *)event withSprite:(Role*)spr
     withTiledMap:(TileMap *)map spritebodys:(CCArray*)bodys{
    NSString *character=[event characters];
	unichar keyCode=[character characterAtIndex:0];
    
    //空白健
    if (keyCode==32) {
    }if (keyCode==NSDownArrowFunctionKey) {
        [spr moveRoleSprite:Down withTileMap:map];
    }else if (keyCode==NSUpArrowFunctionKey) {
        [spr moveRoleSprite:Up withTileMap:map];
    }else if (keyCode==NSLeftArrowFunctionKey) {
        [spr moveRoleSprite:Left withTileMap:map];
    }else if (keyCode==NSRightArrowFunctionKey) {
        [spr moveRoleSprite:Right withTileMap:map];
    }
    
    return YES;
}

-(BOOL) ccKeyUp:(NSEvent *)event withSprite:(Role*)spr
   withTiledMap:(TileMap *)map spritebodys:( CCArray*)bodys{
    //[spr stopAllActions];
    return YES;
}

@end
