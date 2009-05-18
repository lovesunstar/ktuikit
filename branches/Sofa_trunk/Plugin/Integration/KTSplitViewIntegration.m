//
//  KTSplitViewIntegration.m
//  KTUIKit
//
//  Created by Cathy on 13/05/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <KTUIKit/KTSplitVIew.h>
#import "KTSplitViewInspector.h"
 
@implementation KTSplitView ( KTSplitViewIntegration )

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
    [super ibPopulateKeyPaths:keyPaths];

	// Remove the comments and replace "MyFirstProperty" and "MySecondProperty" 
	// in the following line with a list of your view's KVC-compliant properties.
    [[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects:/* @"MyFirstProperty", @"MySecondProperty",*/ nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
    [classes addObject:[KTSplitViewInspector class]];
    [super ibPopulateAttributeInspectorClasses:classes];
	// Replace "KTSplitViewIntegrationInspector" with the name of your inspector class.

}

- (void)ibDidAddToDesignableDocument:(IBDocument *)theDocument
{
	NSLog(@"%@ ibDidAddToDesignableDocument", self);
	[self setDividerOrientation:KTSplitViewDividerOrientation_Vertical];
	[self setDividerFillColor:[NSColor colorWithCalibratedWhite:.3 alpha:1]];
	[self setDividerThickness:1];
	[self setDividerPosition:[self frame].size.width*.5 fromView:KTSplitViewFocusedViewFlag_FirstView];
	[super ibDidAddToDesignableDocument:theDocument];
}



//
////=========================================================== 
//// - drawInContext:
////=========================================================== 
//- (void)drawInContext:(CGContextRef)theContext
//{
////	[[NSColor colorWithCalibratedWhite:.5 alpha:1]set];
////	[NSBezierPath strokeRect:[self bounds]];
////	[[NSColor colorWithCalibratedWhite:.5 alpha:1] set];
////	[NSBezierPath strokeRect:[mFirstView frame]];
////	[NSBezierPath strokeRect:[mSecondView frame]];
////	NSRect aFirstViewRect = NSInsetRect([mFirstView frame], 1.5, 1.5);
////	NSRect aSecondViewRect = NSInsetRect([mSecondView frame], 1.5, 1.5);
////	[[NSColor colorWithCalibratedWhite:1 alpha:1] set];
////	[NSBezierPath strokeRect:aFirstViewRect];
////	[NSBezierPath strokeRect:aSecondViewRect];
//}
//


//
//- (NSView*)hitTest:(NSPoint)thePoint
//{
//	NSLog(@"split view hit test");
//	if([mDivider hitTest:[self convertPoint:thePoint fromView:nil]] == (NSView*)mDivider)
//	{
//		NSLog(@"hit test hit divider!!!!!!!!!!!!");
//		return (NSView*)mDivider;
//	}
//	return self;
//}
//
//- (void)mouseDown:(NSEvent*)theEvent
//{
//	NSLog(@"mouse down in split view");
//}

//=========================================================== 
// - ibDesignableContentView
//=========================================================== 
- (NSView*)ibDesignableContentView
{
	return self;
}
//
//- (BOOL)ibIsChildViewUserMovable:(NSView *)theChildView
//{
////	if(theChildView == (NSView*)mDivider)
////		return YES;
//	return NO;
//}
//
//- (BOOL)ibIsChildViewUserSizable:(NSView *)theChildView
//{
////	if(theChildView == (NSView*)mDivider)
////		return YES;
//	return NO;
//}
//
//- (NSArray*)ibDefaultChildren
//{
//	return nil;//[NSArray arrayWithObjects:mDivider, mFirstView, mSecondView, nil];
//}
//


@end
