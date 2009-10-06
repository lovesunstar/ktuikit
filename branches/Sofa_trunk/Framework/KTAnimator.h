//
//  BWAnimator.h
//  Photoshoot
//
//  Created by Cathy Shive on 7/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString *const KTAnimatorFloatAnimation;
extern NSString *const KTAnimatorRectAnimation;
extern NSString *const KTAnimatorPointAnimation;

typedef enum
{
	kKTAnimationType_EaseInAndOut = 0,
	kKTAnimationType_EaseIn,
	kKTAnimationType_EaseOut,
	kKTAnimationType_Linear
	
}KTAnimationType;


@interface KTAnimator : NSObject 
{
	NSTimer *					mAnimationTimer;
	NSMutableArray *			mAnimationQueue;
	id							wDelegate;
	KTAnimationType				mAnimationType;
	CGFloat						mFramesPerSecond;
	BOOL						mDoubleDuration;
}

@property (readwrite, assign) KTAnimationType animationType;
@property (readwrite, assign) CGFloat framesPerSecond;
@property (readwrite, assign) id delegate;
- (void)animateObject:(NSMutableDictionary*)theAnimationProperties;
- (void)removeAllAnimations;
- (void)doubleDurationOfAllAnimations;
@end
