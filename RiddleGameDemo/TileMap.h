//
//  TileMap.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-11-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapNode.h"

@class MainScene;
@class Box2dSet;

@interface TileMap : NSObject {
    MainScene *_layer;
    Box2dSet *_boxEvm;
    NSMutableArray  *mapNodes;
    
    //地图的行列数
    int COLS;
    int ROWS;
}

@property(nonatomic,assign) NSMutableArray *mapNodes;

@property(nonatomic,assign) int COLS;
@property(nonatomic,assign) int ROWS;

- (void)initWithTileMap:(int)index andLayer:(CCLayer*)layer ;
- (CCTMXTiledMap*) getTileMap;
- (CGPoint) getGameObjectPos:(NSString *) objectLayerName withObjectName:(NSString *) objectName;

- (CGPoint)toRowCol:(CGPoint)pt;
- (CGPoint)ToXY:(CGPoint)pt;

- (BOOL)isCanPassTiled:(CGPoint)ps;
- (BOOL)canPassed:(CGPoint)pt;
- (BOOL)canPassedCOLROW:(CGPoint)pt;
- (BOOL) isTrackTiled:(CGPoint) pos;

-(void) createMapNodes;

@end
