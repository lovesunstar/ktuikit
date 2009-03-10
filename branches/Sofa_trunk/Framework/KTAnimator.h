//
//  BWAnimator.h
//  Photoshoot
//
//  Created by Cathy Shive on 7/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
	kKTAnimationType_Linear = 0,
	kKTAnimationType_EaseIn,
	kKTAnimationType_EaseOut,
	kKTAnimationType_EaseInAndOut
	
}KTAnimationType;


@interface KTAnimator : NSObject 
{
	NSTimer *					mAnimationTimer;
	NSMutableArray *			mAnimationQueue;
	id							wDelegate;
	KTAnimationType				mAnimationType;
	CGFloat						mFrameRate;
	BOOL						mDoubleDuration;
}

@property (readwrite, assign) KTAnimationType animationType;
@property (readwrite, assign) CGFloat frameRate;
@property (readwrite, assign) id delegate;
- (void)animateObject:(NSMutableDictionary*)theAnimationProperties;
- (void)removeAllAnimations;
- (void)doubleDurationOfAllAnimations;
@end
