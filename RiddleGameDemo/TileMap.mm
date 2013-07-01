//
//  TileMap.m
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-11-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TileMap.h"
#import "MainScene.h"
#import "Box2dSet.h"

#define tileMap_Tag 1

@implementation TileMap

@synthesize mapNodes;

@synthesize COLS;
@synthesize ROWS;

//加载TMX地图文件
- (void)initWithTileMap:(int)index andLayer:(CCLayer*)layer {
    NSString *mapName=[NSString stringWithFormat:@"tileGame%d.tmx",index];
    
    CCTMXTiledMap *tileMap=[CCTMXTiledMap tiledMapWithTMXFile:mapName];
    
    [layer addChild:tileMap z:-1 tag:tileMap_Tag];
    
    ROWS=tileMap.mapSize.height;
    COLS=tileMap.mapSize.width;

    [self setLayer:layer];
    //设置图块box2d的层
    [self setTileBox];

}

- (void) setLayer:(CCLayer*)layer{
    _layer=(MainScene*)layer;
}

- (CCTMXTiledMap*) getTileMap{
    CCNode *tileMapNode=[_layer getChildByTag:tileMap_Tag];
    
    CCTMXTiledMap *tileMap=(CCTMXTiledMap*)tileMapNode;
    
    return tileMap;
}

//得到地图中的层
- (CCTMXLayer*)getTileLayerFormMap:(NSString*)mapLayerName{
    return [[self getTileMap]layerNamed:mapLayerName];
}

//得到对象层中的一个对象位置
- (CGPoint) getGameObjectPos:(NSString *) objectLayerName withObjectName:(NSString *) objectName{
	CCTMXObjectGroup *objects=[[self getTileMap] objectGroupNamed:objectLayerName];
	NSAssert(objects!=nil,@"objectLayer object grounp not found!");
    
	NSMutableDictionary *spawnPoint=[objects objectNamed:objectName];
	NSAssert(spawnPoint!=nil,@"SpwanPoint object not found!");
	
	int x=[[spawnPoint valueForKey:@"x"]intValue];
	int y=[[spawnPoint valueForKey:@"y"]intValue];
	
	return CGPointMake(x, y);
}

//获得图块的box对象
- (void) setTileBox{
    //获得block层
    CCTMXLayer *block=[self getTileLayerFormMap:@"block"];
    
    CCTMXTiledMap *tileMap=[self getTileMap];
    for (int i=0; i<tileMap.mapSize.width; i++) {
        for (int j=0; j<tileMap.mapSize.height; j++) {
            //当前的位置
            CGPoint rt=ccp(i,j);
            //遍历对象
            int tileGID=[block tileGIDAt:rt];
            if (tileGID) {
                NSDictionary *properties=[[self getTileMap]propertiesForGID:tileGID];
                
                if (properties) {
                    NSString *colloion=[properties valueForKey:@"blockTiled"];
                    //如果砖块类型符合
                    if (colloion) {
                        //设置tilebox
                        [_layer.boxEvm setTileBody:[self ToXY:rt]];
                    }else{
                        continue;
                    }
                }
            }

        }
    }
}

//是否为楼梯
-(BOOL) isTrackTiled:(CGPoint) pos{
    CCTMXLayer *track=[[self getTileMap] layerNamed:@"track"];
    int tileGID=[track tileGIDAt:pos];
    
    if (tileGID) {
        NSDictionary *properties=[[self getTileMap] propertiesForGID:tileGID];
        if (properties) {
			NSString *collision=[properties valueForKey:@"isTrack"];
			if (collision&&[collision compare:@"1"]==NSOrderedSame) {
				return YES;
			}
		}
    }
    
    return NO;
}

//坐标转换
- (CGPoint)toRowCol:(CGPoint)pt{
    CCTMXTiledMap *tileMap=[self getTileMap];
    int x=pt.x/tileMap.tileSize.width;
    int y=((tileMap.mapSize.height*tileMap.tileSize.height)-pt.y)/
    tileMap.tileSize.height;
    
    return ccp(x,y);
}

- (CGPoint)ToXY:(CGPoint)pt{
    CCTMXTiledMap *tileMap=[self getTileMap];
    //CCLOG(@"%d,%d",(int)pt.x,(int)pt.y);
    CGPoint rt=ccp(pt.x*tileMap.tileSize.width,
                   (tileMap.mapSize.height*tileMap.tileSize.height)-(pt.y*tileMap.tileSize.height));
    return rt;
}


//检测是否可以通行的图块（AL用）
-(BOOL)isCanPassTiled:(CGPoint)ps{
    CCTMXLayer *meta=[self getTileLayerFormMap:@"meta"];//获取meta层
    
    int tileGid=[meta tileGIDAt:ps];
    
    if (tileGid) {
        NSDictionary *propertices=[[self getTileMap] propertiesForGID:tileGid];
        if (propertices) {
            NSString *collision=[propertices valueForKey:@"canFalling"];
            if (collision&&[collision compare:@"1"]==NSOrderedSame) {
                return NO;//不能通过
            }
        }
    }
    return YES;//可以通过
}

//是否能够通过
- (BOOL)canPassed:(CGPoint)pt{
    //获得block层
    CCTMXLayer *block=[self getTileLayerFormMap:@"block"];
    
    CGPoint tilePos=[self toRowCol:pt];
    
    int tileGID=[block tileGIDAt:tilePos];
    
    if (tileGID) {
        NSDictionary *properties=[[self getTileMap]propertiesForGID:tileGID];
        
        if (properties) {
            NSString *colloion=[properties valueForKey:@"blockTiled"];
            if (colloion&&[colloion compare:@"1"]==NSOrderedSame) {
                return NO;//不能通过
            }
        }
    }
    
    return YES;//可以通过
}

-(BOOL)canPassedCOLROW:(CGPoint)pt{
    //获得block层
    CCTMXLayer *block=[self getTileLayerFormMap:@"block"];
    
    int tileGID=[block tileGIDAt:pt];
    
    if (tileGID) {
        NSDictionary *properties=[[self getTileMap]propertiesForGID:tileGID];
        
        if (properties) {
            NSString *colloion=[properties valueForKey:@"blockTiled"];
            if (colloion&&[colloion compare:@"1"]==NSOrderedSame) {
                return NO;//不能通过
            }
        }
    }
    
    return YES;//可以通过

}

//产生节点
-(void) createMapNodes{
    mapNodes = [[NSMutableArray alloc] init];
    
    for(int i=0;i<ROWS * COLS;++i){
        int x = i % COLS;
        int y = i / COLS;
        MapNode *mapNode = [[MapNode alloc] init];
        mapNode.pos = ccp(x,y);
        [mapNodes addObject:mapNode];
    }

}

- (void)dealloc{
    
    [_layer release];
    
    [super dealloc];
}

@end
