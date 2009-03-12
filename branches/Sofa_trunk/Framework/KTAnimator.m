//
//  BWAnimator.m
//  Photoshoot
//
//  Created by Cathy Shive on 7/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "KTAnimator.h"

@interface NSObject (KTAnimatorDelegate)
- (void)animatorIsUpdatingAnimation:(NSDictionary*)theAnimation;
- (BOOL)isAnimationOverForStartValue:(CGFloat)theStartValue endValue:(CGFloat)theEndValue newValue:(CGFloat)theNewValue;
- (void)animatorStarted;
- (void)animatorEnded;
@end


@interface KTAnimator (Private)
- (void)updateAnimation;
- (void)startTimer;
- (void)endTimer;
@end

@implementation KTAnimator
@synthesize animationType = mAnimationType;
@synthesize framesPerSecond = mFramesPerSecond;
@synthesize delegate = wDelegate;
- (id)init
{
	if(self = [super init])
	{
		mAnimationTimer = nil;	
		mAnimationQueue = [[NSMutableArray alloc] init];
		mFramesPerSecond = 60.0;
	}
	return self;
}

- (void)dealloc
{
	if([mAnimationTimer isValid])
		[mAnimationTimer invalidate];
	[mAnimationTimer release];
	[mAnimationQueue release];
	wDelegate = nil;
	[super dealloc];
}

- (void)removeAllAnimations
{
	if([mAnimationTimer isValid])
		[mAnimationTimer invalidate];
	[mAnimationQueue removeAllObjects];
}

- (void)animateObject:(NSMutableDictionary*)theAnimationProperties
{

	
	
	// animations can either be set with a duration or a speed
	// if the speed is set, we ignore a duration if it's set as well
	if([theAnimationProperties valueForKey:@"speed"]!=nil)
	{
		// CS: at the moment, speed-based animations are not implemented
		// if the speed is set, we'll raise an exception telling the programmer to set a duration instead
		[NSException raise:@"KTAnimator" format:[NSString stringWithFormat:@"Speed configurations are not yet supported, please set a duration instead."]];
		
		// once we implement the speed-based updating, we'll uncomment out the code below and remove the exception
		
		/*
		if([theAnimationProperties valueForKey:@"duration"]!=nil)
		{
			NSLog(@"%@ found a speed setting and a durration setting, removing the durations", self);
			[theAnimationProperties removeObjectForKey:@"duration"];
		}
		*/
	}
	
	
//	if([theAnimationProperties valueForKey:@"duration"]!=nil)
//	{
//		NSNumber * aCurrentValue = [[theAnimationProperties valueForKey:@"object"] valueForKey:[theAnimationProperties valueForKey:@"keyPath"]];
//		NSNumber * aStartValue = [theAnimationProperties valueForKey:@"startValue"];
//		NSNumber * anEndValue = [theAnimationProperties valueForKey:@"endValue"];
//		// adjust the duration if it's necessary - this allows for interruptions in an animation, not sure if this is what the
//		// animator should do...
//		if([aCurrentValue floatValue] != [aStartValue floatValue])
//		{
//			float aDistance = [anEndValue floatValue] - [aStartValue floatValue];
//			float aDiff = [aCurrentValue floatValue] - [aStartValue floatValue];
//			float aPct = 0;
//			if(aDistance!=0)
//				aPct = aDiff/aDistance;
//			float aDuration = [[theAnimationProperties valueForKey:@"duration"]floatValue];
//			aDuration *= aPct;
//			[theAnimationProperties setValue:[NSNumber numberWithFloat:aPct] forKey:@"duration"];
//		}
//	}
	
	// check to see if we're already animating this value for this object
	int anAnimationCount = [mAnimationQueue count];
	int i;
	id	anObjectToRemove = nil;
	for(i = 0; i < anAnimationCount; i++)
	{
		id	anObject = [theAnimationProperties valueForKey:@"object"];
		id	aCurrentObject = [[mAnimationQueue objectAtIndex:i] valueForKey:@"object"];
		if(aCurrentObject == anObject)
		{
			if([[theAnimationProperties valueForKey:@"keyPath"] isEqualToString:[[mAnimationQueue objectAtIndex:i] valueForKey:@"keyPath"]])
			{
				// we have the same object and the same keypath
				// remove the object in the queue, we don't care about this animation anymore
				anObjectToRemove = [mAnimationQueue objectAtIndex:i];
			}
		}
	}
	
	
	NSLog(@"#########################################################");
	if(anObjectToRemove!=nil)
	{
		[mAnimationQueue removeObject:anObjectToRemove];
	}
	
	// add object to queue
	[mAnimationQueue addObject:theAnimationProperties];
	// if this is the first object and the timer isn't already going, start the timer
	if(		[mAnimationQueue count] == 1 
		&&  ![mAnimationTimer isValid] )	  
	{
		[self startTimer];
	}
}


- (void)performUpdateAnimation:(NSTimer*)theTimer
{
	[self performSelectorOnMainThread:@selector(updateAnimation) withObject:nil waitUntilDone:NO];
//	[self updateAnimation];
}


- (void)updateAnimation
{

	/*
		CS:  All of the animaitons get updated every time the timer fires.  We have different options for how we calculate the new value 
		in the animation:
			• based on the kind of animation (linear, eased)
			• based on the type of *value* we're animating (frame or a float).  
			• based on whether the animation is speed or duration based.
		I plan to break this down into several methods to keep the logic more readable.
	*/ 
//	NSLog(@"***************************************UPDATE KTANIMATION************************************************");

	// get ready to build a list of animations that are finished after this frame and can be removed from the queue
	NSMutableArray *	aListOfAnimationsToRemove = [[NSMutableArray alloc] init];
	
	// update each animation in the queue
	NSInteger anAnimationCount = [mAnimationQueue count];
	NSInteger i;
	
	for(i = 0; i < anAnimationCount; i++)
	{
		// get the info we need to calculate a new value
		NSDictionary *		anAnimationObject = [mAnimationQueue objectAtIndex:i];
		id					aNewValue = nil;
		BOOL				anAnimationIsComplete = NO;
		
		// speed-based animation
		if([anAnimationObject valueForKey:@"speed"]!=nil)
		{
			// not implemented yet
		}
		
		// duration-based animation
		else if([anAnimationObject valueForKey:@"duration"]!=nil)
		{
			// if there's no start date, make one
			if([anAnimationObject valueForKey:@"startDate"]==nil)
				[anAnimationObject setValue:[NSDate date] forKey:@"startDate"]; 
			
			CGFloat				aDuration = [[anAnimationObject valueForKey:@"duration"]floatValue];
			CFTimeInterval		anElapsedTime = -[[anAnimationObject valueForKey:@"startDate"] timeIntervalSinceNow];
			CGFloat				aNormalizedLocationInAnimation = (anElapsedTime / aDuration);	
			
			// For a duration based animtation, we know that the animation should be over if the duration < the time that has passed
			// if this is the case we just use the end value for the new value - it the animation is not smooth, this could cause a jumpy effect at the
			// end of the animation
			anAnimationIsComplete = (fabs(anElapsedTime) > aDuration);
			if(anAnimationIsComplete)
			{
				aNewValue = [anAnimationObject valueForKey:@"endValue"];
			}
			else
			{
				// is this a frame animation?
				if([[anAnimationObject valueForKey:@"keyPath"] isEqualToString:@"frame"])
				{
					NSRect		aStartingRect = [[anAnimationObject valueForKey:@"startValue"] rectValue];
					NSRect		anEndingRect = [[anAnimationObject valueForKey:@"endValue"] rectValue];
					NSRect		aFrameToSet = NSZeroRect;
					
					CGFloat		aSinEaseNormalizedLocationInAnimation = 1.0 - (.5 * sin((aNormalizedLocationInAnimation+.5) * ((3.14*2) / 2.0)) + .5);
					
					// frame animation - animate each part of the rect individually
					CGFloat aStartValue;
					CGFloat anEndValue;
					CGFloat aDistanceOfAnimation;
					
					// x pos
					aStartValue = aStartingRect.origin.x;
					anEndValue = anEndingRect.origin.x;
					aDistanceOfAnimation = (anEndValue - aStartValue);
					aFrameToSet.origin.x = aStartValue + (aSinEaseNormalizedLocationInAnimation * aDistanceOfAnimation);
					
					// y pos
					aStartValue = aStartingRect.origin.y;
					anEndValue = anEndingRect.origin.y;
					aDistanceOfAnimation = (anEndValue - aStartValue);
					aFrameToSet.origin.y = aStartValue + (aSinEaseNormalizedLocationInAnimation * aDistanceOfAnimation);
					
					// width
					aStartValue = aStartingRect.size.width;
					anEndValue = anEndingRect.size.width;
					aDistanceOfAnimation = (anEndValue - aStartValue);
					aFrameToSet.size.width = aStartValue + (aSinEaseNormalizedLocationInAnimation * aDistanceOfAnimation);
					
					// height
					aStartValue = aStartingRect.size.height;
					anEndValue = anEndingRect.size.height;
					aDistanceOfAnimation = (anEndValue - aStartValue);
					aFrameToSet.size.height = aStartValue + (aSinEaseNormalizedLocationInAnimation * aDistanceOfAnimation);					
								
					// set the new value as an NSValue with a rect
					aNewValue = [NSValue valueWithRect:aFrameToSet];						
				}
				else // this is animating just an arbitrary float value
				{
					CGFloat	anEndValue = [[anAnimationObject valueForKey:@"endValue"] floatValue];
					CGFloat	aStartValue = [[anAnimationObject valueForKey:@"startValue"] floatValue];
					CGFloat	aDistanceOfAnimation = (anEndValue - aStartValue);
					CGFloat aFloatValueToSet = anEndValue;
					
					switch(mAnimationType)
					{
						case kKTAnimationType_Linear:
							aFloatValueToSet = aStartValue + (aNormalizedLocationInAnimation * aDistanceOfAnimation);
						case kKTAnimationType_EaseInAndOut:
						{
							CGFloat		aSinEaseNormalizedLocationInAnimation = 1.0 - (.5 * sin((aNormalizedLocationInAnimation+.5) * ((3.14*2) / 2.0)) + .5);
	//						CGFloat		anExponentialEasedNormalizedLocationInAnimation = (1.0 - pow(2, - (aNormalizedLocationInAnimation * aNormalizedLocationInAnimation / 0.1)));
							aFloatValueToSet = aStartValue + (aSinEaseNormalizedLocationInAnimation * aDistanceOfAnimation);
						}
						break;
						default:
						break;
					}
					
					// set the new value to an NSNumber from a float
					aNewValue = [NSNumber numberWithFloat:aFloatValueToSet];
				}
			}
		}
		else
		{
			NSLog(@"cannot update animation, there is no duration or speed set");
		}
		
		
		// if we have determined that this animation is complete, add it to list of animations to remove and adjust this new value so that it is the requested end value
		if(anAnimationIsComplete)
		{
			[aListOfAnimationsToRemove addObject:anAnimationObject];
		}

		// set the value
		[[anAnimationObject valueForKey:@"object"] setValue:aNewValue forKey:[anAnimationObject valueForKey:@"keyPath"]];
		// let delegate know we've updated
		if(wDelegate)
		{
			if([wDelegate respondsToSelector:@selector(animatorIsUpdatingAnimation:)])
				[wDelegate animatorIsUpdatingAnimation:anAnimationObject];
		}
	}
	
	// We've finished updating all the animations 

	// remove any objects that need to be removed
	if([aListOfAnimationsToRemove count] > 0)
	{
		NSLog(@"removing %d animations from queue", [aListOfAnimationsToRemove count]);
		[mAnimationQueue removeObjectsInArray:aListOfAnimationsToRemove];
	}
	[aListOfAnimationsToRemove release];
	
	// if we don't have any more animations to update, stop the timer
	if([mAnimationQueue count] == 0)
	{
		[self endTimer];
	}
}



- (BOOL)isAnimationOverForStartValue:(CGFloat)theStartValue endValue:(CGFloat)theEndValue newValue:(CGFloat)theNewValue
{
	BOOL aBoolToReturn = NO;
	
	if(theStartValue < theEndValue)
	{
		if(	theNewValue >= theEndValue)
			aBoolToReturn = YES;
	}
	else
	{
		if(	theNewValue <= theEndValue)
			aBoolToReturn = YES;
	}
	return aBoolToReturn;
}


- (void)startTimer
{
	// start the timer
	mAnimationTimer = [[NSTimer scheduledTimerWithTimeInterval:(1.0/mFramesPerSecond)
										  target:self 
										  selector:@selector(performUpdateAnimation:)
										  userInfo:nil
										  repeats:YES] retain];

	[[NSRunLoop currentRunLoop] addTimer:mAnimationTimer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:mAnimationTimer forMode:NSModalPanelRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:mAnimationTimer forMode:NSEventTrackingRunLoopMode];
	
	if([wDelegate respondsToSelector:@selector(animatorStarted)])
		[wDelegate animatorStarted];
}

- (void)endTimer
{
	if([mAnimationTimer isValid])
	{
		[mAnimationTimer invalidate];
		[mAnimationTimer release];
		mAnimationTimer=nil;
	}
	
	if([wDelegate respondsToSelector:@selector(animatorEnded)])
		[wDelegate animatorEnded];
}

- (void)setDelegate:(id)theDelegate
{
	wDelegate = theDelegate;
}


- (void)doubleDurationOfAllAnimations
{
	mDoubleDuration = YES;
}


@end
