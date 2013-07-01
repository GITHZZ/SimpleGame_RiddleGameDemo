//
//  MapNode.m
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-12-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapNode.h"

@implementation MapNode
@synthesize pos;
@synthesize f;
@synthesize g;
@synthesize h;
@synthesize searchIndex;
@synthesize routeIndex;
@synthesize isVisited;
@synthesize parent;
-(id) init{
    if (self = [super init]){
        pos.x = pos.y = 0;
        f = g = h = 0;
        searchIndex =  routeIndex = 0;
        isVisited=NO;
        parent = nil;
    }
    return self;
}
-(NSComparisonResult) costComp:(MapNode *)node2{
    return [[NSNumber numberWithInt:f] compare:[NSNumber numberWithInt:node2.f]] ;
}
@end
