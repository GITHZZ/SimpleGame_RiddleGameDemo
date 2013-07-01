//
//  MainScene.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-11-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TileMap.h"
#import "Role.h"
#import "Controller.h"
#import "Monster.h"
#import "Box2dSet.h"

#define GAME_TESTING_MODEL 1

@interface MainScene : CCLayer {
    TileMap *map;
    Role *player;
    Monster *monster;
    
    Controller *controller;
    
    CGSize screenSize;
    
    //box2d环境变量
    Box2dSet *_boxEvm;
}

@property (assign,readwrite) Box2dSet *boxEvm;
@property (assign,readwrite) Role *player;

+(CCScene *) scene;

@end
