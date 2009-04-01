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
		mAnimator = nil;
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
	if(mAnimator == nil)
	{
		CGPoint aPositionToSet = NSPointToCGPoint([self frame].origin);
		if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			aPositionToSet.y = thePosition;
		else
			aPositionToSet.x = thePosition;
		NSRect aNewFrame = [self frame];
		aNewFrame.origin = NSPointFromCGPoint(aPositionToSet);
		
		NSArray * anAnimationArray = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self, NSViewAnimationTargetKey,
																										 [NSValue valueWithRect:[self frame]], NSViewAnimationStartFrameKey,
																										 [NSValue valueWithRect:aNewFrame], NSViewAnimationEndFrameKey, nil]];
		mAnimator = [[NSViewAnimation alloc] initWithViewAnimations:anAnimationArray];			
		[mAnimator setDelegate:self];																						
		[mAnimator setDuration: theTimeInSeconds];
		[mAnimator setAnimationCurve:NSAnimationEaseInOut];
		[mAnimator setAnimationBlockingMode: NSAnimationBlocking];
		[mAnimator startAnimation];
	}
}


//=========================================================== 
// - animationDidEnd
//===========================================================
- (void)animationDidEnd:(NSAnimation *)theAnimation
{
	if(theAnimation == mAnimator)
	{
		[mAnimator release];
		mAnimator = nil;	
		[[self splitView] resetResizeInformation];	
	}
}

//=========================================================== 
// - setFrame:time
//===========================================================
- (void)setFrame:(NSRect)theFrame
{	
	
//	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Vertical)
//	{
//		// clip min & max positions
//		float aPositionToCheck = 0;//[self minPosition];
//		
//		if(		aPositionToCheck > 0
//			&&	theFrame.origin.x <= aPositionToCheck)
//		{
//			theFrame.origin.x = aPositionToCheck;
//			if(mIsInDrag == YES)
//				[[NSCursor resizeRightCursor] set];
//		}
//		
//		aPositionToCheck = 0;//[self maxPosition];
//		if(		aPositionToCheck > 0
//			&&	theFrame.origin.x >= aPositionToCheck)
//		{
//			theFrame.origin.x = aPositionToCheck;
//			if(mIsInDrag == YES)
//				[[NSCursor resizeLeftCursor] set];
//		}
//	}
//	else if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
//	{
//		float aPositionToCheck = 0;//[self minPosition];
//		if(		aPositionToCheck > 0
//			&&	theFrame.origin.y < aPositionToCheck)
//		{
//			theFrame.origin.y = aPositionToCheck;
//			if(mIsInDrag == YES)
//				[[NSCursor resizeUpCursor] set];
//		}	
//		
//		aPositionToCheck = 0;//[self maxPosition];
//		if(		aPositionToCheck > 0
//			&&	theFrame.origin.y >= aPositionToCheck)
//		{
//			theFrame.origin.y = aPositionToCheck;
//			if(mIsInDrag == YES)
//				[[NSCursor resizeDownCursor] set];
//		}
//	}
	
	[super setFrame:theFrame];
	[[self splitView] layoutViews];
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
