//
//  SpriteDef.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*用于存储精灵的box2d的数据信息*/

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface SpriteDef : NSObject {
    b2BodyDef _spriteDef;
    b2FixtureDef _spriteFixture;
    b2Body    *_b2SpriteBody;
}

@property (readwrite) b2BodyDef spriteDef;
@property (readwrite) b2FixtureDef spriteFixture;
@property (readwrite) b2Body    *b2SpriteBody;

-(id)initWithspriteDef:(b2BodyDef)spriteDef withFixture:(b2FixtureDef)spriteFixture
              withBody:(b2Body*)b2SpriteBody;

@end
