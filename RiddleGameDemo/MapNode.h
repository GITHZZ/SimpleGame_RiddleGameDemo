//
//  MapNode.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MapNode : NSObject {
    CGPoint pos;
    int f;
    int g;
    int h;
    int searchIndex;
    int routeIndex;
    BOOL isVisited;
    MapNode *parent;
}
@property(nonatomic,assign)CGPoint pos;
@property(nonatomic,assign)int f;
@property(nonatomic,assign)int g;
@property(nonatomic,assign)int h;
@property(nonatomic,assign)int searchIndex;
@property(nonatomic,assign)int routeIndex;
@property(nonatomic,assign)BOOL isVisited;
@property(nonatomic,assign)MapNode *parent;
-(NSComparisonResult) costComp:(MapNode *)node2;

@end
