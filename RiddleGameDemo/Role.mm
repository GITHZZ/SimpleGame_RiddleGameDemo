//
//  Role.mm
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Role.h"

#define role_speed 5

@implementation Role

//Monster调用此方法
- (id)initWithMonsterSprite:(NSString*)fileName withLayer:(CCLayer*)ly position:(CGPoint)pos{
    roleType=Role_Monster;
    
    if (!(self=[self initWithPlayerSprite:fileName withLayer:ly position:pos withBoxEvm:nil])) {
        CCLOG(@"fail to init Monster Sprite!");
        return nil;
    }
    return self;
}

//生成player调用此方法
- (id)initWithPlayerSprite:(NSString *)fileName withLayer:(CCLayer *)ly
                position:(CGPoint)pos withBoxEvm:(Box2dSet*)boxEvm{
    if (roleType!=Role_Monster) {
        roleType=Role_Player;
        CCLOG(@"[Info]Role:Sprite Type is Player!");
    }else{
        CCLOG(@"[Info]Role:Sprite Type is Monster!");
    }
    
    if ((self=[super init])) {
        //加载纹理
        CCTexture2D *texPlayer=[[CCTextureCache sharedTextureCache]addImage:fileName];
        
        //循环创建每个方向动作循环
        RoleAction=[[NSMutableArray alloc]init];
        NSMutableArray *animFrames=[NSMutableArray array];//存放每个动作的帧序列
        for (int i=0; i<4; i++) {
            [animFrames removeAllObjects];
            for (int j=0; j<3; j++) {
                CCSpriteFrame *frame=[CCSpriteFrame frameWithTexture:texPlayer
                                                                rect:CGRectMake(j*32, i*48, 32, 48)];
                [animFrames addObject:frame];
            }
            //用帧序列创建动画
            CCAnimation *animation=[CCAnimation animationWithFrames:animFrames delay:0.1f];
            //创建CCAnimate对象用来控制动画播放
            CCAnimate *animate=[CCAnimate actionWithAnimation:animation];
            [RoleAction addObject:[CCRepeatForever actionWithAction:animate]];
        }
        
        self.position=pos;
        
        if (roleType==Role_Player) {
            _boxEvm=boxEvm;
        }
      
        [self runAction:[RoleAction objectAtIndex:1]];

    }
    return self;
}

//player精灵的移动
//tile文件左上角坐标为（0，0）
- (void)moveRoleSprite:(RoleDirector)dir withTileMap:(TileMap*)map{
    if(roleType==Role_Player){
        SpriteDef *roleDef=[_boxEvm.spritesbody objectAtIndex:0];
        b2Vec2 vec;
        
        //判断是否能够向上运动
        if(![map isTrackTiled:[map toRowCol:ccp(self.position.x,self.position.y)]]
           &&(dir==Up||dir==Down)){
            return;
        }
    
        
        //根据方向进行移动
        switch (dir) {
            case Up:
                vec=b2Vec2(0,role_speed);
                break;
            case Down:
                vec=b2Vec2(0,-role_speed);
                break;
            case Left:
                vec=b2Vec2(-role_speed,0);
                break;
            case Right:
                vec=b2Vec2(role_speed ,0);
                break;
            default:
                break;
        }
        
        roleDef.b2SpriteBody->IsAwake();
        roleDef.b2SpriteBody->SetLinearVelocity(vec);
    }else{
        CCLOG(@"[ERROR]:Role:Role Type is not Player!");
    }
    
    //运行动画
    [self playRoleWalkAnimation:dir];
}

//运行动画
- (void)playRoleWalkAnimation:(RoleDirector)roleState{
    if (roleState==oldState) {
        return;
    }
    
    [self stopAllActions];
    switch (roleState) {
        //up和down是同样的动作
        case Up:
        case Down:
            [self runAction:[RoleAction objectAtIndex:2]];
            break;
        case Left:
            [self runAction:[RoleAction objectAtIndex:1]];
            break;
        case Right:
            [self runAction:[RoleAction objectAtIndex:3]];
            break;
        default:
            break;
    }
    
    oldState=roleState;
}

//监测精灵是否有碰撞
-(BOOL) spriteIsContactSprite:(CCSprite *) spr{
	CGRect spriteRect=CGRectMake(self.position.x-self.contentSize.width/2,
								 self.position.y-self.contentSize.height/2,
								 self.contentSize.width,
								 self.contentSize.height);
	
	CGRect enemyRect=CGRectMake(spr.position.x-spr.contentSize.width/2,
								spr.position.y-spr.contentSize.height/2,
								spr.contentSize.width-5,
								spr.contentSize.height);
	
	if (CGRectIntersectsRect(spriteRect, enemyRect)) {
		return YES;
	}
	return NO;
}

@end
