//
//  KTOpenGLLayer.h
//  KTUIKit
//
//  Created by Cathy on 19/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTViewLayout.h"

@class KTOpenGLView;
@class KTLayoutManager;

@interface KTOpenGLLayer : NSResponder <KTViewLayout> 
{
	@private
		KTLayoutManager *		mLayoutManager;
		NSRect					mFrame;
		CGFloat					mAlpha;
		NSMutableArray *		mSublayers;
		KTOpenGLLayer *			mSuperlayer;
		KTOpenGLView *			wView;
}

@property (readwrite, assign) NSRect frame;
@property (readwrite, assign) CGFloat alpha;
@property (readwrite, retain) KTLayoutManager * viewLayoutManager;
@property (readwrite, assign) KTOpenGLView * view;
@property (readwrite, assign) KTOpenGLLayer * superlayer;
@property (readwrite, retain) NSMutableArray * sublayers;



- (id)initWithFrame:(NSRect)theFrame;
- (NSRect)bounds;
- (void)notifiyLayersViewDidReshape;
- (void)viewDidReshape;
- (void)addSublayer:(KTOpenGLLayer*)theSublayer;
- (void)removeSublayer:(KTOpenGLLayer*)theSublayer;

- (void)drawLayers;
- (void)draw;
- (KTOpenGLLayer*)hitTest:(NSPoint)thePoint;
- (void)setNeedsDisplay:(BOOL)theBool;

- (NSRect)convertRect:(NSRect)theRect fromLayer:(KTOpenGLLayer*)theLayer;
- (NSPoint)convertPoint:(NSPoint)thePoint fromLayer:(KTOpenGLLayer*)theLayer;
- (NSRect)convertRectToViewRect:(NSRect)theRect;
- (NSPoint)convertPointToViewPoint:(NSPoint)thePoint;

// should prolly add methods to convert to/from window and screen coords too

- (CGFloat)positionX;
- (void)setPositionX:(CGFloat)thePosition;
- (CGFloat)positionY;
- (void)setPositionY:(CGFloat)thePosition;
- (CGFloat)width;
- (void)setWidth:(CGFloat)thePosition;
- (CGFloat)height;
- (void)setHeight:(CGFloat)thePosition;

@end
