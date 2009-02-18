//
//  KTOpenGLView.m
//  KTUIKit
//
//  Created by Cathy on 16/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KTOpenGLView.h"

@interface KTOpenGLView (Private)

- (void)setup2DCamera;
- (void)setup3DCamera;

@end

@implementation KTOpenGLView
//=========================================================== 
// - defaultPixelFormat
//=========================================================== 
+ (NSOpenGLPixelFormat*)defaultPixelFormat
{
	NSOpenGLPixelFormatAttribute anAttributes[] = {
		NSOpenGLPFAAccelerated,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFANoRecovery,
		NSOpenGLPFAColorSize, (NSOpenGLPixelFormatAttribute)32,
		(NSOpenGLPixelFormatAttribute)0
	};
    return [[(NSOpenGLPixelFormat *)[NSOpenGLPixelFormat alloc] initWithAttributes:anAttributes] autorelease];
}


//=========================================================== 
// - initWithFrame:
//=========================================================== 
- (id)initWithFrame:(NSRect)theFrame
{
		
	NSOpenGLPixelFormat * aPixelFormat = [KTOpenGLView defaultPixelFormat];
	[super initWithFrame:theFrame pixelFormat:aPixelFormat];
	
	NSOpenGLContext * anOpenGLContext = [self openGLContext];
	[anOpenGLContext makeCurrentContext];
	
	// swap interval
	GLint swapInterval = 1;
	[anOpenGLContext setValues:&swapInterval forParameter:NSOpenGLCPSwapInterval];

	// Layout
	KTLayoutManager * aLayoutManger = [[[KTLayoutManager alloc] initWithView:self] autorelease];
	[self setViewLayoutManager:aLayoutManger];
	[self setAutoresizesSubviews:NO];
	
	// Styles
	KTStyleManager * aStyleManager = [[[KTStyleManager alloc] initWithView:self] autorelease];
	[self setStyleManager:aStyleManager];
	
	// For Debugging
	[self setLabel:@"KTOpenGLView"];
	
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{	
	[super encodeWithCoder:theCoder];
	
	[theCoder encodeObject:[self viewLayoutManager] forKey:@"layoutManager"];
	[theCoder encodeObject:[self styleManager] forKey:@"styleManager"];
	[theCoder encodeObject:[self label] forKey:@"label"];

}

//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
	if (![super initWithCoder:theCoder])
		return nil;
		
	NSOpenGLPixelFormat * aPixelFormat = [KTOpenGLView defaultPixelFormat];
	[super initWithFrame:[self frame] pixelFormat:aPixelFormat];
	
	NSOpenGLContext * anOpenGLContext = [self openGLContext];
	[anOpenGLContext makeCurrentContext];
	
	// swap interval
	GLint swapInterval = 1;
	[anOpenGLContext setValues:&swapInterval forParameter:NSOpenGLCPSwapInterval];
	
		
	KTLayoutManager * aLayoutManager = [theCoder decodeObjectForKey:@"layoutManager"];
	[aLayoutManager setView:self];
	[self setViewLayoutManager:aLayoutManager];
	[self setAutoresizesSubviews:NO];
	[self setAutoresizingMask:NSViewNotSizable];
	
	KTStyleManager * aStyleManager = [theCoder decodeObjectForKey:@"styleManager"];
	[aStyleManager setView:self];
	[self setStyleManager:aStyleManager];
	
	[self setLabel:[theCoder decodeObjectForKey:@"label"]];
	return self;
}

//=========================================================== 
// - dealloc
//=========================================================== 
- (void)dealloc
{	
	[mLayoutManager release];
	[mStyleManager release];
	[mLabel release];
	[super dealloc];
}


//=========================================================== 
// - renewGState
//=========================================================== 
- (void)renewGState 
{
    NSWindow *window = [self window];
    if ([window respondsToSelector:@selector(disableScreenUpdatesUntilFlush)]) {
        [window disableScreenUpdatesUntilFlush];
    }
    [super renewGState];
}


//=========================================================== 
// - prepareOpenGL
//=========================================================== 
- (void) prepareOpenGL
{
    GLint parm = 1;
    [[self openGLContext] setValues:&parm forParameter:NSOpenGLCPSwapInterval];

    glDisable (GL_ALPHA_TEST);
    glDisable (GL_DEPTH_TEST);
    glDisable (GL_SCISSOR_TEST);
    glDisable (GL_DITHER);
    glDisable (GL_CULL_FACE);
	
    glColorMask (GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    glDepthMask (GL_FALSE);
    glStencilMask (0);
    glHint (GL_TRANSFORM_HINT_APPLE, GL_FASTEST);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

//=========================================================== 
// - reshape
//=========================================================== 
- (void) reshape
{
	[super reshape];
}

//=========================================================== 
// - update
//=========================================================== 
- (void)update
{
	[super update];
}

#pragma mark -
#pragma mark Drawing
//=========================================================== 
// - drawRect:
//=========================================================== 
- (void)drawRect:(NSRect)theRect
{	
	// this is a bit hacky, but want to make sure
	// that the entire bounds are used and not an update rect 
	// from 'setNeedsDisplay:inRect:' because we're always
	// clearing all the pixels on every redraw
	theRect = [self bounds];
	
	NSOpenGLContext * aCurrentContext = [self openGLContext];
	[aCurrentContext makeCurrentContext];

//	if(mOpenGLViewType == kBW3DOpenGLView)
//		[self setup3DCamera];
//	else
//		[self setup2DCamera];
	
	[self setup2DCamera];
	float aRed, aGreen, aBlue, anAlpha;
	[[[[self styleManager] backgroundColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&aRed green:&aGreen blue:&aBlue alpha:&anAlpha];
	
	glClearColor(aRed, aGreen, aBlue, anAlpha);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	[self drawInContext:aCurrentContext];
	[aCurrentContext flushBuffer];
		
}

//=========================================================== 
// - drawInContext:
//=========================================================== 
- (void)drawInContext:(NSOpenGLContext*)theContext
{
	// subclasses can override this to do custom drawing over the styles
}



//=========================================================== 
// - setup2DCamera
//=========================================================== 
- (void) setup2DCamera
{
	NSRect aVisibleRectBounds = [self visibleRect];

    // set viewing
	glViewport (0, 0, aVisibleRectBounds.size.width, aVisibleRectBounds.size.height);
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity ();
	glOrtho(aVisibleRectBounds.origin.x, 
			aVisibleRectBounds.origin.x+aVisibleRectBounds.size.width, 
			aVisibleRectBounds.origin.y,
			aVisibleRectBounds.origin.y+aVisibleRectBounds.size.height,
			-1, 1);
	
    // set modeling
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}


//=========================================================== 
// - setup3DCamera
//=========================================================== 
- (void) setup3DCamera
{	
    NSRect aBounds = [self bounds];
    int aWidth = aBounds.size.width;
    int aHeight = aBounds.size.height;
	if(aHeight==0)
		aHeight = 1;
		
    // set viewing
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glViewport(0, 0, aWidth, aHeight); 
	gluPerspective( 60, ((float)aWidth)/((float)(aHeight)), 0.1, 100000.0);
	
    // set modeling
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
	
	float aZPos = -1.0 * (aBounds.size.height*0.5) / tan( 3.14159 / 6.0 );
	glTranslatef(-aBounds.size.width*0.5, -aBounds.size.height*0.5, aZPos );
}


#pragma mark -
#pragma mark Layout protocol
//=========================================================== 
// - setViewLayoutManager:
//===========================================================
- (void)setViewLayoutManager:(KTLayoutManager*)theLayoutManager
{
	if(mLayoutManager != theLayoutManager)
	{
		[mLayoutManager release];
		mLayoutManager = [theLayoutManager retain];
	}
}

//=========================================================== 
// - viewLayoutManager
//===========================================================
- (KTLayoutManager*)viewLayoutManager
{
	return mLayoutManager;
}

//=========================================================== 
// - setFrame:
//===========================================================
- (void)setFrame:(NSRect)theFrame
{
	[super setFrame:theFrame];
	
	NSArray * aSubviewList = [self children];
	int aSubviewCount = [aSubviewList count];
	int i;
	for(i = 0; i < aSubviewCount; i++)
	{
		 id aSubview = [aSubviewList objectAtIndex:i];
		
		// if the subview conforms to the layout protocol, tell its layout
		// manager to refresh its layout
		if( [aSubview conformsToProtocol:@protocol(KTViewLayout)] )
		{
			[[(id<KTViewLayout>)aSubview viewLayoutManager] refreshLayout];
		}
	}
}

//=========================================================== 
// - frame
//===========================================================
- (NSRect)frame
{
	return [super frame];
}

//=========================================================== 
// - parent
//===========================================================
- (id<KTViewLayout>)parent
{
	if([[self superview] conformsToProtocol:@protocol(KTViewLayout)])
		return (id<KTViewLayout>)[self superview];
	else
		return nil;
}

//=========================================================== 
// - children
//===========================================================
- (NSArray*)children
{
	return nil;
}



#pragma mark -
#pragma mark KTStyledView protocol
//=========================================================== 
// - setStyleManager:
//===========================================================
- (void)setStyleManager:(KTStyleManager*)theStyleManager
{
	if(mStyleManager != theStyleManager)
	{
		[mStyleManager release];
		mStyleManager = [theStyleManager retain];
	}
}

//=========================================================== 
// - styleManager
//===========================================================
- (KTStyleManager*)styleManager
{
	return mStyleManager;
}

//=========================================================== 
// - window
//===========================================================
- (NSWindow *)window
{
	return [super window];
}

#pragma mark -
#pragma mark KTView protocol
//=========================================================== 
// - setLabel:
//===========================================================
- (void)setLabel:(NSString*)theLabel
{
	if(mLabel != theLabel)
	{
		[mLabel release];
		mLabel = [[NSString alloc] initWithString:theLabel];
	}
}

//=========================================================== 
// - label
//===========================================================
- (NSString*)label
{
	return mLabel;
}

@end
