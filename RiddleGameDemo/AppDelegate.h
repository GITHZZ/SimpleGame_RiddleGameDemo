//
//  AppDelegate.h
//  RiddleGameDemo
//
//  Created by 何遵祖 on 12-11-29.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"

@interface RiddleGameDemoAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	MacGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet MacGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
