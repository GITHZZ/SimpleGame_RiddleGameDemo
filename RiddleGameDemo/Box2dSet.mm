//
//  Box2dSet.m
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-4.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Box2dSet.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


@implementation Box2dSet

@synthesize world=_world;
@synthesize spritesbody=_spritesbody;

-(id)initWithBox2dEvm:(CCLayer*)layer{
    if (self=[super init]) {
        [self setLayer:layer];
        [self initWithBox2dEvm];
        
        _spritesbody=[[CCArray alloc] init];
    }
    return self;
}

-(void)setLayer:(CCLayer*)ly{
    _layer=ly;
}

//设置box2d画面边缘
-(void)setTileEdge{
    CGSize screenSize=[[CCDirector sharedDirector]winSize];
    
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    b2Body* groundBody = _world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;
    
    // bottom
    groundBox.SetAsEdge(b2Vec2(0,70/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,70/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // top
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // left
    groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // right
    groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
}

//设置砖块的body
-(void)setTileBody:(CGPoint)tilePos{
    b2BodyDef tileBodyDef;
    tileBodyDef.position.Set((tilePos.x/PTM_RATIO)+0.5f, (tilePos.y/PTM_RATIO)-0.5f);
    
    b2Body *tileBody=_world->CreateBody(&tileBodyDef);
    b2PolygonShape tileBox;
    
    tileBox.SetAsBox(0.5f, 0.49f);
    tileBody->CreateFixture(&tileBox,0);
}

-(void)initWithBox2dEvm{//初始化box2d环境
    //初始化重力
    b2Vec2 gravity;
    gravity.Set(0.0f, -10.0f);
    
    //是否睡眠
    bool doSleep = true;
    
    //设置世界
    _world = new b2World(gravity, doSleep);
    
    _world->SetContinuousPhysics(true);
    
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    _world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    //		flags += b2DebugDraw::e_jointBit;
    //		flags += b2DebugDraw::e_aabbBit;
    //		flags += b2DebugDraw::e_pairBit;
    //		flags += b2DebugDraw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);
    
    [self setTileEdge];
    
    [[CCScheduler sharedScheduler]scheduleSelector:@selector(tick:) forTarget:self interval:1/60 paused:false];
}

//添加精灵到时间中
-(void)addSpriteToWorld:(CCSprite*)spr z:(NSInteger)z tag:(NSInteger) aTag{
    [_layer addChild:spr z:z tag:aTag];
    
    //设置Spr的body
    b2BodyDef b2PlayerDef;
    b2PlayerDef.type=b2_dynamicBody;
    b2PlayerDef.position.Set(spr.position.x/PTM_RATIO, spr.position.y/PTM_RATIO);
    b2PlayerDef.userData=spr;
    
    b2Body *playerBody=_world->CreateBody(&b2PlayerDef);
    
    b2PolygonShape playerShape;
    playerShape.SetAsBox(0.4f, 0.75f);
    
    b2FixtureDef playerFixture;
    playerFixture.shape=&playerShape;
    playerBody->CreateFixture(&playerFixture);
    
    SpriteDef *playerDef=[[SpriteDef alloc] initWithspriteDef:b2PlayerDef withFixture:playerFixture
                                                     withBody:playerBody];
    //增添到数组中
    [_spritesbody addObject:playerDef];
    [playerDef release];
}

-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	_world->Step(dt, velocityIterations, positionIterations);
    
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
}

//测试用
-(void)mydraw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	_world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

-(void)dealloc{
    [super dealloc];
}

@end
