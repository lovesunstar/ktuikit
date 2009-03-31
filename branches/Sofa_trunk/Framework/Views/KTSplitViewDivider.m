//
//  KTSplitViewDivider.m
//  KTUIKit
//
//  Created by Cathy on 30/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import "KTSplitViewDivider.h"
#import "KTSplitView.h"
#import "KTAnimator.h"
#import <Quartz/Quartz.h>

@interface KTSplitViewDivider ()
@property (nonatomic, readwrite, assign) KTSplitView * splitView;
@end

@implementation KTSplitViewDivider
@synthesize splitView = wSplitView;
//=========================================================== 
// - initWithSplitView
//===========================================================
- (id)initWithSplitView:(KTSplitView*)theSplitView
{
	if(self = [super initWithFrame:NSZeroRect])
	{
		wSplitView = theSplitView;
		mAnimator = [[KTAnimator alloc] init];
		[mAnimator setDelegate:self];
		[[self styleManager] setBackgroundColor:[NSColor redColor]];
	}
	return self;
}

//=========================================================== 
// - dealloc
//===========================================================
- (void)dealloc
{
	[mAnimator release];
	[super dealloc];
}

//=========================================================== 
// - animateDividerToPosition:time
//===========================================================
- (void)animateDividerToPosition:(float)thePosition time:(float)theTimeInSeconds
{		
//	CGPoint aPositionToSet = NSPointToCGPoint([self frame].origin);
//	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
//		aPositionToSet.y = thePosition;
//	else
//		aPositionToSet.x = thePosition;
//	NSRect aNewFrame = [self frame];
//	aNewFrame.origin = NSPointFromCGPoint(aPositionToSet);
//	[[self animator] setFrame:aNewFrame];


	NSRect						aDividerFrame = [self frame];
	NSMutableDictionary *		aDividerAnimation = [[NSMutableDictionary alloc] init];
	
	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
		[aDividerAnimation setValue:self forKey:@"object"];
		[aDividerAnimation setValue:@"position" forKey:@"keyPath"];
		[aDividerAnimation setValue:[NSNumber numberWithFloat:aDividerFrame.origin.y] forKey:@"startValue"];
		[aDividerAnimation setValue:[NSNumber numberWithFloat:thePosition] forKey:@"endValue"];
		[aDividerAnimation setValue:[NSNumber numberWithFloat:theTimeInSeconds] forKey:@"duration"];
	}
	else
	{
		[aDividerAnimation setValue:self forKey:@"object"];
		[aDividerAnimation setValue:@"position" forKey:@"keyPath"];
		[aDividerAnimation setValue:[NSNumber numberWithFloat:aDividerFrame.origin.x] forKey:@"startValue"];
		[aDividerAnimation setValue:[NSNumber numberWithFloat:thePosition] forKey:@"endValue"];
		[aDividerAnimation setValue:[NSNumber numberWithFloat:theTimeInSeconds] forKey:@"duration"];			
	}
	[mAnimator animateObject:aDividerAnimation];
	[aDividerAnimation release];
}



//---------------------------------------------------------------------------------------
//	setPosition -  KVO for animator
//---------------------------------------------------------------------------------------
- (void)setPosition:(CGFloat)thePosition
{
	NSRect aFrame = [self frame];

	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
		[self setFrame:NSMakeRect(aFrame.origin.x, thePosition, aFrame.size.width, aFrame.size.height)];
	}
	else
	{
		[self setFrame:NSMakeRect(thePosition, aFrame.origin.y, aFrame.size.width, aFrame.size.height)];
	}
}


//---------------------------------------------------------------------------------------
//	position -  KVO for animator
//---------------------------------------------------------------------------------------
- (CGFloat)position
{
	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
		return [self frame].origin.y;
	else
		return [self frame].origin.x;
}




//
////=========================================================== 
//// - defaultAnimationForKey
////===========================================================
//+ (id)defaultAnimationForKey:(NSString *)theKey 
//{
//    if ([theKey isEqualToString:@"frame"]) 
//	{
//        // By default, animate border color changes with simple linear interpolation to the new color value.
//        return [CABasicAnimation animation];
//    } else {
//        // Defer to super's implementation for any keys we don't specifically handle.
//        return [super defaultAnimationForKey:theKey];
//    }
//}
//
//





////=========================================================== 
//// - setPosition
////===========================================================
//- (void)setPosition:(CGPoint)thePosition
//{
//	NSRect aFrame = [self frame];
//	aFrame.origin = NSPointFromCGPoint(thePosition);
//	[self setFrame:aFrame];
//}
//
//
////=========================================================== 
//// - animateDividerToPosition:time
////===========================================================
//- (CGPoint)position
//{
//	return NSPointToCGPoint([self frame].origin);
//}
//


//=========================================================== 
// - setFrame:time
//===========================================================
- (void)setFrame:(NSRect)theFrame
{	
	
	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Vertical)
	{
		// clip min & max positions
		float aPositionToCheck = 0;//[self minPosition];
		
		if(		aPositionToCheck > 0
			&&	theFrame.origin.x <= aPositionToCheck)
		{
			theFrame.origin.x = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeRightCursor] set];
		}
		
		aPositionToCheck = 0;//[self maxPosition];
		if(		aPositionToCheck > 0
			&&	theFrame.origin.x >= aPositionToCheck)
		{
			theFrame.origin.x = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeLeftCursor] set];
		}
	}
	else if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
		float aPositionToCheck = 0;//[self minPosition];
		if(		aPositionToCheck > 0
			&&	theFrame.origin.y < aPositionToCheck)
		{
			theFrame.origin.y = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeUpCursor] set];
		}	
		
		aPositionToCheck = 0;//[self maxPosition];
		if(		aPositionToCheck > 0
			&&	theFrame.origin.y >= aPositionToCheck)
		{
			theFrame.origin.y = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeDownCursor] set];
		}
	}
	
	[super setFrame:theFrame];
	[[self splitView] layoutViews];
//	[[self splitView] display];
}



//
//
////=========================================================== 
//// - mouseDown
////===========================================================
//- (void)mouseDown:(NSEvent*)theEvent
//{
//	if([[self splitView] adjustable] == NO)
//		return;
//}


//=========================================================== 
// - mouseDragged
//===========================================================
- (void)mouseDragged:(NSEvent*)theEvent
{
	if([[self splitView] adjustable] == NO)
		return;
		
	NSPoint	aMousePoint = [[self splitView] convertPoint:[theEvent locationInWindow] fromView:nil];
	NSRect	aSplitViewBounds = [[self splitView] bounds];
	NSRect	aSplitViewFrame = [[self splitView] frame];
	NSRect	aDividerBounds = [self bounds];
	NSRect	aDividerFrame = [self frame];
	
	if([[self splitView] dividerOrientation]  == KTSplitViewDividerOrientation_Horizontal)
	{
		float aPoint = floor(aMousePoint.y - aDividerBounds.size.height*.5);
		
		if(		aPoint >= aSplitViewBounds.origin.x 
			&&	aPoint <= aSplitViewFrame.size.height-aDividerBounds.size.height )
		{
			
			[[NSCursor resizeUpDownCursor] set];
			NSRect aRect = aDividerFrame;
			[self setFrame:NSMakeRect(aRect.origin.x, aPoint,
									  aRect.size.width, aRect.size.height) ];
		}
	}
	else 
	{
		float aPoint = floor(aMousePoint.x-aDividerBounds.size.width*.5);
		if(aPoint >= aSplitViewBounds.origin.y && aPoint <= aSplitViewFrame.size.width-aDividerBounds.size.width)
		{
			[[NSCursor resizeLeftRightCursor] set];
			NSRect aRect = aDividerFrame;
			[self setFrame:NSMakeRect(aPoint, aRect.origin.y,
									  aRect.size.width, aRect.size.height) ];
			
		}
	}
	mIsInDrag = YES;
	[[self splitView] display];
}

//=========================================================== 
// - mouseUp
//===========================================================
- (void)mouseUp:(NSEvent*)theEvent
{
	[[NSCursor arrowCursor] set];
	mIsInDrag = NO;
	[[self splitView] resetResizeInformation];
}



@end
