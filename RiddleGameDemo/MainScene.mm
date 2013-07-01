//
//  MainScene.m
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-11-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainScene.h"

// MainScene implementation
@implementation MainScene

@synthesize boxEvm=_boxEvm;
@synthesize player;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *layer = [MainScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)loadTileMap{
    [map initWithTileMap:1 andLayer:self];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //窗口大小
        screenSize=[[CCDirector sharedDirector]winSize];
        
        //初始化box2d环境
        self.boxEvm=[[Box2dSet alloc] initWithBox2dEvm:self];
        
        //加载地图文件
        map=[[TileMap alloc]init];
        [self loadTileMap];

        //加载player文件
        CGPoint playerPos=[map getGameObjectPos:@"gamePlayer" withObjectName:@"SpawnPoint"];
        player=[[Role alloc] initWithPlayerSprite:@"man.png" withLayer:self position:playerPos
                                         withBoxEvm:self.boxEvm];
        [self.boxEvm addSpriteToWorld:player z:1 tag:1];

        //加载Monster
        CGPoint monsterPos=[map getGameObjectPos:@"gamePlayer" withObjectName:@"MonsterObj"];
        monster=[[Monster alloc]initWithMonsterSprite:@"man.png" withLayer:self position:monsterPos];
        monster.color=ccBLACK;
        monster.anchorPoint=ccp(0,0.66);
        [self addChild:monster];
          
        //添加控制层
        controller=[[Controller alloc]init];
        
        self.isKeyboardEnabled=YES;
    
        [self scheduleUpdate];

        [self schedule:@selector(catchPlayer:) interval:0.1f];

    }
	return self;
}

//游戏循环部分
- (void)update:(ccTime)dt{
    //怪物循环
    [monster doAStarWalk:dt withTileMap:map];
    
    //如果发生碰撞玩家归位
    if ([player spriteIsContactSprite:monster]) {
        player.color=ccBLUE;
    }else{
        player.color=ccWHITE;
    }
}

- (void)catchPlayer:(ccTime)dt{
    //如果是停止状态就寻路
    if (monster.monsterState==Stop) {
        //进行寻路
        [monster doAStarSearch:monster.position TO:player.position withMap:map];
    }
}

//游戏控制部分
- (BOOL)ccKeyDown:(NSEvent *)event{
    return [controller ccKeyDown:event withSprite:player withTiledMap:map spritebodys:self.boxEvm.spritesbody];
}

- (BOOL)ccKeyUp:(NSEvent *)event{
    return [controller ccKeyUp:event withSprite:player withTiledMap:map spritebodys:self.boxEvm.spritesbody];
}

//draw 
-(void)draw{
#if GAME_TESTING_MODEL
    
    [self.boxEvm mydraw];
    
#endif
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [map release];
    [controller release];
    
	[super dealloc];
}

@end
