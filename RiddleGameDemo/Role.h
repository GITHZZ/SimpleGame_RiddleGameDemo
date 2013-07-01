//
//  Role.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TileMap.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Box2dSet.h"

typedef enum RoleType{
    Role_Player,
    Role_Monster,
}RoleType;

//only support four director
typedef enum RoleDirector{
    Up=0,
    Down=2,
    Left=1,
    Right=3,
}RoleDirector;

@interface Role : CCSprite {
    RoleType roleType;
    Box2dSet *_boxEvm;
    NSMutableArray *RoleAction;
    
    CGPoint target;//目标位置
    
    float           oldAngle;
    int             oldDir;
    RoleDirector    oldState;
}

- (id)initWithMonsterSprite:(NSString*)fileName withLayer:(CCLayer*)ly position:(CGPoint)pos;
- (id)initWithPlayerSprite:(NSString *)fileName withLayer:(CCLayer *)ly
                  position:(CGPoint)pos withBoxEvm:(Box2dSet*)boxEvm;

- (void)moveRoleSprite:(RoleDirector)dir withTileMap:(TileMap*)map;
- (void)playRoleWalkAnimation:(RoleDirector)roleState;

- (BOOL)spriteIsContactSprite:(CCSprite *) spr;

@end
