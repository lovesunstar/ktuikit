//
//  BWAnimator.h
//  Photoshoot
//
//  Created by Cathy Shive on 7/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class KTAnimator;
@interface NSObject (KTANimatorDelegateMethods)
- (void)animator:(KTAnimator*)theAnimator didStartAnimation:(NSDictionary*)theAnimation;
- (void)animator:(KTAnimator*)theAnimator didUpdateAnimation:(NSDictionary*)theAnimation;
- (void)animator:(KTAnimator*)theAnimator didEndAnimation:(NSDictionary*)theAnimation;
@end

extern NSString *const KTAnimatorAnimationNameKey;
extern NSString *const KTAnimatorAnimationObjectKey;
extern NSString *const KTAnimatorAnimationKeyPathKey;
extern NSString *const KTAnimatorAnimationDurationKey;
extern NSString *const KTAnimatorAnimationSpeedKey;
extern NSString *const KTAnimatorAnimationStartValueKey;
extern NSString *const KTAnimatorAnimationEndValueKey;
extern NSString *const KTAnimatorAnimationTypeKey;
extern NSString *const KTAnimatorFloatAnimation;
extern NSString *const KTAnimatorRectAnimation;
extern NSString *const KTAnimatorPointAnimation;
extern NSString *const KTAnimatorAnimationCurveKey;

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
	CGFloat						mFramesPerSecond;
	BOOL						mDoubleDuration;
}

@property (readwrite, assign) CGFloat framesPerSecond;
@property (readwrite, assign) id delegate;
- (void)animateObject:(NSMutableDictionary*)theAnimationProperties;
- (void)removeAllAnimations;
- (void)doubleDurationOfAllAnimations;
@end
