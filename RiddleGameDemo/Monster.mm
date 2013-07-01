//
//  Monster.m
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Monster.h"

#define monster_speed 150
#define PI 3.141592654

@implementation Monster

@synthesize monsterState;

-(id)initWithMonsterSprite:(NSString*)fileName withLayer:(CCLayer*)ly position:(CGPoint)pos{
    if ((self=[super initWithMonsterSprite:fileName withLayer:ly position:pos])) {
        //four
        dirs[0]=ccp(1,0);
        dirs[1]=ccp(0,-1);
        dirs[2]=ccp(-1,0);
        dirs[3]=ccp(0,1);
        
        curIndex=0;
        monsterState=ReachTarget;
    }
    return self;
}

//设置旋转度数
-(void) setOrientation:(float)angle{
    RoleDirector dir=Left;
    
    if (oldDir==dir) {
        return;
    }
    
    if (angle>=179) {
        dir = Left;
    }else if (angle==-90) {
        dir = Up;
    }else if (angle==90) {
        dir=Down;
    }else if (angle==0) {
        dir=Right;
    }
    
    [self playRoleWalkAnimation:dir];
}

-(MonsterState)chasing:(ccTime)dt withTileMap:(TileMap*)map{
    CGPoint pos = self.position;
    CGPoint vr = ccpSub(target, pos);
    //CCLOG(@"%f,%f",vr.x,vr.y);
    if(ccpLength(vr) <= monster_speed * dt){
        self.position = target;
        return ReachTarget;
    }
    vr = ccpNormalize(vr);
    float angle = (ccpToAngle(vr) / PI * 180.0);
    [self setOrientation:angle];
    vr = ccpMult(vr,monster_speed);
    
    pos = ccpAdd(pos,ccpMult(vr, dt));
    if ([map canPassed:pos]){
        self.position = pos;
        return Chasing;
    }else {
        return MeetObstacle;
    }
}


/*AStar算法*/
-(void) doAStarWalk:(ccTime)dt withTileMap:(TileMap*)tileMap{
    if (monsterState == Stop){
        return;
    }
    switch (monsterState) {
        case ReachTarget:{
            if(curIndex >= path.count){
                monsterState = Stop;
                return;
            }
            MapNode *node = [path objectAtIndex:curIndex++];
            if (node == nil){
                return;
            }
            CGPoint curPos = node.pos;
            target = [tileMap ToXY:curPos];
            monsterState = Chasing;
            break;
        }
        case Chasing:{
            monsterState = [self chasing:dt withTileMap:tileMap];
            break;
        }
        default:
            break;
    }
}

-(void) generatePath:(MapNode*)targetNode{
    MapNode *node = targetNode;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [path removeAllObjects];
    [array addObject:node];
    
    while (node.parent != nil) {
        [array addObject:node.parent];
        node = node.parent;
    }
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    [array release];
    if (path != nil){
        [path release];
    }
    path = [[NSMutableArray alloc] initWithArray:[enumerator allObjects]];
    curIndex = 0;
    monsterState = ReachTarget;
}

-(BOOL) doAStarSearch:(CGPoint)from TO:(CGPoint)to withMap:(TileMap*)map{
    [map createMapNodes];
    
    NSMutableArray *open = [[NSMutableArray alloc] init];//open列表中放入八个节点比较
    NSMutableArray *close = [[NSMutableArray alloc] init];//比较结束后放到close节点
	
	//转换成为图块坐标
	CGPoint fromCR=[map toRowCol:from];
	CGPoint toCR=[map toRowCol:to];
	//获取目标节点
	MapNode *node=[map.mapNodes objectAtIndex:toCR.y*map.COLS+toCR.x];

    //开始节点
	MapNode *start=[map.mapNodes objectAtIndex:fromCR.y*map.COLS+fromCR.x];
    [open addObject:start];
    //如果添加完毕进入循环
    while (open!=NULL){
        [open sortUsingSelector:@selector(costComp:)];
        //f值最小的节点
        static int minIndex=0;
        MapNode *minNode=[open objectAtIndex:minIndex];
        
        //把最小的节点放到数组中
        [close addObject:minNode];
        
        //判断是否为目标节点
        if (minNode.pos.x==node.pos.x&&minNode.pos.y==node.pos.y) {
            //移动
            [self generatePath:minNode];
            return YES;//成功
        }
        
        //移除所有元素
        [open removeAllObjects];
        //循环判断节点中的周围的子节点
        for(int i=0;i<4;i++){
            //遍历八个方向
            CGPoint nextPos=ccpAdd(minNode.pos, dirs[i]);
            //产生节点
            MapNode *nextNode=[map.mapNodes objectAtIndex:nextPos.y*map.COLS+nextPos.x];
            
            //节点可以访问而且是可以通行的方块
            if ([map canPassedCOLROW:nextNode.pos]&&![open containsObject:nextNode]
                &&![close containsObject:nextNode]&&!nextNode.isVisited&&[map isCanPassTiled:nextNode.pos]){
                //斜边为14 直边为10（假设）
                if (dirs[i].x!=0&&dirs[i].y!=0) {//代表斜边
                    nextNode.g=minNode.parent.g+14;
                }else{
                    nextNode.g=minNode.parent.g+10;
                }
                
                //计算h
                nextNode.h=minNode.parent.h+((abs(toCR.x-nextPos.x)+abs(toCR.y-nextPos.y))*10);
                nextNode.f=nextNode.g+nextNode.h;
                //添加到open数组之中
                [open addObject:nextNode];
                nextNode.parent=minNode;//父节点
            }
            nextNode.isVisited=YES;//表示已经访问过了
        }

        //如果没有合适的节点返回
        if ([open count]==0) {
            //如果不符合条件就跳过失败
            if (minNode.parent==nil) {
                return NO;
            }
            
            for(int i=0;i<4;i++){
                //遍历四个方向
                CGPoint nextPos=ccpAdd(minNode.pos, dirs[i]);
                //产生节点
                MapNode *nextNode=[map.mapNodes objectAtIndex:nextPos.y*map.COLS+nextPos.x];
                nextNode.isVisited=NO;
            }
            [open addObject:minNode.parent];
        }
    }
    
	return NO;//失败
}

@end
