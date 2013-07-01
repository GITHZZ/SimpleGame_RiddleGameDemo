//
//  Monster.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*AL寻路模式为A*算法*/

#import "Role.h"

typedef enum MonsterState{
    Stop,
    Chasing,
    ReachTarget,
    MeetObstacle,
}MonsterState;

@interface Monster : Role {
    MonsterState  monsterState;
    CGPoint dirs[4];
    NSMutableArray *path;
    
    int  curIndex;
}

@property(nonatomic,assign) MonsterState monsterState;

-(id)initWithMonsterSprite:(NSString*)fileName withLayer:(CCLayer*)ly position:(CGPoint)pos;

-(void) doAStarWalk:(ccTime)dt withTileMap:(TileMap*)tileMap;
-(BOOL) doAStarSearch:(CGPoint)from TO:(CGPoint)to withMap:(TileMap*)map;

@end
