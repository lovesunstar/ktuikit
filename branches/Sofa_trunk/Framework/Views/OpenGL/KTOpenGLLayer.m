//
//  KTOpenGLLayer.m
//  KTUIKit
//
//  Created by Cathy on 19/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KTOpenGLLayer.h"
#import <OpenGL/glu.h>
#import "KTLayoutManager.h"
#import "KTOpenGLView.h"

@implementation KTOpenGLLayer

@synthesize frame = mFrame;
@synthesize alpha = mAlpha;
@synthesize viewLayoutManager = mLayoutManager;
@synthesize sublayers = mSublayers;
@synthesize superlayer = mSuperlayer;
@synthesize view = wView;
//=========================================================== 
// - initWithFrame
//===========================================================
- (id)initWithFrame:(NSRect)theFrame
{
	if(self = [super init])
	{
		mFrame = theFrame;
		mSublayers = [[NSMutableArray alloc] init];
		mLayoutManager = [[KTLayoutManager alloc] initWithView:self];
		mAlpha = 1.0;
		wView = nil;
		mAnchorPoint = NSMakePoint(0.5, 0.5);
	}
	return self;
}


//=========================================================== 
// - dealloc
//===========================================================
- (void)dealloc
{
	[mSublayers release];
	[mLayoutManager release];
	wView = nil;
	[super dealloc];
}

//=========================================================== 
// - addSublayer
//===========================================================
- (void)addSublayer:(KTOpenGLLayer*)theSublayer
{
	if(theSublayer)
	{
		// take care of the responder chain
		[theSublayer setNextResponder:self];
		// tell sublayer about its super layer
		[theSublayer setSuperlayer:self];
		// tell the sublayer about its view
		[theSublayer setView:[self view]];
		
		// add
		[mSublayers addObject:theSublayer];
	}
}


//=========================================================== 
// - removeSublayer
//===========================================================
- (void)removeSublayer:(KTOpenGLLayer*)theSublayer
{
	if(theSublayer)
		[mSublayers removeObject:theSublayer];
}


//=========================================================== 
// - drawLayers
//===========================================================
- (void)drawLayers
{
	// draw ourself
	[self draw];
	
	// draw sublayers
	for(KTOpenGLLayer * aSublayer in [self sublayers])
		[aSublayer drawLayers];
}


//=========================================================== 
// - draw
//===========================================================
- (void)draw
{
	
}

//=========================================================== 
// - setNeedsDisplay
//===========================================================
- (void)setNeedsDisplay:(BOOL)theBool
{
	[[self view] setNeedsDisplay:YES];
}


//=========================================================== 
// - setView
//===========================================================
- (void)setView:(KTOpenGLView*)theView
{
	wView = theView;
	[mSublayers makeObjectsPerformSelector:@selector(setView:) withObject:theView];
}


//=========================================================== 
// - notifiyLayersViewDidReshape
//===========================================================
- (void)notifiyLayersViewDidReshape
{
//	[self viewDidReshape];
//	[mSublayers makeObjectsPerformSelector:@selector(notifiyLayersViewDidReshape:) withObject:nil];
}


//=========================================================== 
// - viewDidReshape
//===========================================================
- (void)viewDidReshape
{
}



#pragma mark Coordinate System
//=========================================================== 
// - convertRect:fromLayer
//===========================================================
- (NSRect)convertRect:(NSRect)theRect fromLayer:(KTOpenGLLayer*)theLayer
{
	NSRect aRectToReturn = NSZeroRect;
	aRectToReturn.origin = [self convertPoint:theRect.origin fromLayer:theLayer];
	aRectToReturn.size = theRect.size;
	return aRectToReturn;
}

//=========================================================== 
// - convertPoint:fromLayer
//===========================================================
- (NSPoint)convertPoint:(NSPoint)thePoint fromLayer:(KTOpenGLLayer*)theLayer
{
	NSPoint aPointToReturn = NSZeroPoint;
	// convert the point to the view's coordinate system
	NSPoint aLayerOrigin = [theLayer frame].origin;
	NSPoint aViewPoint = NSMakePoint(aLayerOrigin.x + thePoint.x, aLayerOrigin.y + thePoint.y);
	// where is this point in our coordinate system?
	aPointToReturn.x = aViewPoint.x - [self frame].origin.x;
	aPointToReturn.y = aViewPoint.y - [self frame].origin.y;
	return aPointToReturn;
}

//=========================================================== 
// - convertRectToViewRect
//===========================================================
- (NSRect)convertRectToViewRect:(NSRect)theRect
{
	NSRect aRectToReturn = NSZeroRect;
	return aRectToReturn;
}

//=========================================================== 
// - convertPointToViewPoint
//===========================================================
- (NSPoint)convertPointToViewPoint:(NSPoint)thePoint
{
	NSPoint aPointToReturn = NSZeroPoint;
	return aPointToReturn;
}

//=========================================================== 
// - positionX
//===========================================================
- (CGFloat)positionX
{
	return [self frame].origin.x;
}


//=========================================================== 
// - setPositionX
//===========================================================
- (void)setPositionX:(CGFloat)thePosition
{
	NSRect aFrame = [self frame];
	aFrame.origin.x = thePosition;
	[self setFrame:aFrame];
}

//=========================================================== 
// - positionY
//===========================================================
- (CGFloat)positionY
{
	return [self frame].origin.y;
}

//=========================================================== 
// - setPositionY
//===========================================================
- (void)setPositionY:(CGFloat)thePosition
{
	NSRect aFrame = [self frame];
	aFrame.origin.y = thePosition;
	[self setFrame:aFrame];
}

//=========================================================== 
// - width
//===========================================================
- (CGFloat)width
{
	return [self frame].size.width;
}

//=========================================================== 
// - setWidth
//===========================================================
- (void)setWidth:(CGFloat)thePosition
{
	NSRect aFrame = [self frame];
	aFrame.size.width = thePosition;
	[self setFrame:aFrame];
}


//=========================================================== 
// - height
//===========================================================
- (CGFloat)height
{
	return [self frame].size.height;
}

//=========================================================== 
// - setHeight
//===========================================================
- (void)setHeight:(CGFloat)thePosition
{
	NSRect aFrame = [self frame];
	aFrame.size.height = thePosition;
	[self setFrame:aFrame];
}


#pragma mark Rotation
- (void)setRotation:(CGFloat)theRotation
{
	mRotation = theRotation;
	// do we rotate sublayers?
}

- (void)setAnchorPoint:(NSPoint)theAnchorPoint
{
	mAnchorPoint = theAnchorPoint;
}




#pragma mark Events
//=========================================================== 
// - hitTest
//===========================================================
- (KTOpenGLLayer*)hitTest:(NSPoint)thePoint
{
	KTOpenGLLayer * aLayerToReturn = nil;
	
	for(KTOpenGLLayer * aSublayer in [self sublayers])
	{
		aLayerToReturn = [aSublayer hitTest:thePoint];
		if(aLayerToReturn)
			break;
	}
	
	if(aLayerToReturn == nil)
	{
		if(NSPointInRect(thePoint, [self frame]))
			aLayerToReturn = self;
	}
	return aLayerToReturn;
}






#pragma mark KTLayoutManager protocol
//=========================================================== 
// - setFrame
//===========================================================
- (void)setFrame:(NSRect)theFrame
{
	mFrame = theFrame;
	for(KTOpenGLLayer * aSublayer in [self sublayers])
		[[aSublayer viewLayoutManager] refreshLayout];
}

//=========================================================== 
// - frame
//===========================================================
- (NSRect)frame
{
	// our frame is dependent on our rotation
	// and anchor point
	/*
		r = a * (1 - pow(2, E)) / (1 + E*cos(T))
		-------
		a: half width
		b = half height
		E = sqr( pow(2,a) - pow(2, b)) / a
		or
		E = sqr( 1 - ( pow(2, b) / pow(2, a)))
	*/
	
	return mFrame;
}

//=========================================================== 
// - bounds
//===========================================================
- (NSRect)bounds
{
	return NSMakeRect(0, 0, mFrame.size.width, mFrame.size.height);
}

//=========================================================== 
// - parent
//===========================================================
- (id<KTViewLayout>)parent
{
	id<KTViewLayout> aParent = nil;
	if(mSuperlayer!=nil)
		aParent = mSuperlayer;
	else if(wView != nil)
		aParent = wView;
		
	return aParent;
}

//=========================================================== 
// - children
//===========================================================
- (NSArray*)children
{
	return mSublayers;
}


@end