//
//  Box2dSet.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-4.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*box2d环境的基本设置类*/

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "SpriteDef.h"

@interface Box2dSet : NSObject {
    //box2d环境变量
    b2World* _world;
	GLESDebugDraw *m_debugDraw;
    
    //要和哪个层绑定
    CCLayer *_layer;
    
    //精灵管理
    CCArray *_spritesbody;
}

@property (nonatomic,assign) b2World *world;
@property (nonatomic,assign) CCArray *spritesbody;

-(id)initWithBox2dEvm:(CCLayer*)layer;
-(void)setTileBody:(CGPoint)tilePos;

-(void)initWithBox2dEvm;
-(void)addSpriteToWorld:(CCSprite*)spr z:(NSInteger)z tag:(NSInteger) aTag;

-(void)mydraw;

@end
