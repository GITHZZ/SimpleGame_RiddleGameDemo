//
//  SpriteDef.m
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpriteDef.h"

@implementation SpriteDef

@synthesize spriteDef=_spriteDef;
@synthesize spriteFixture=_spriteFixture;
@synthesize b2SpriteBody=_b2spriteBody;

-(id)initWithspriteDef:(b2BodyDef)spriteDef withFixture:(b2FixtureDef)spriteFixture withBody:(b2Body*)b2SpriteBody{
    if(self=[super init]){
        self.spriteDef=spriteDef;
        self.spriteFixture=_spriteFixture;
        self.b2SpriteBody=b2SpriteBody;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    
    //销毁对象
    free(_b2SpriteBody);
}

@end
