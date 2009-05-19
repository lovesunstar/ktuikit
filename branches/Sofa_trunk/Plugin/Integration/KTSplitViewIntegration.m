//
//  KTSplitViewIntegration.m
//  KTUIKit
//
//  Created by Cathy on 13/05/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <KTUIKit/KTUIKit.h>
#import <KTUIKit/KTSplitViewDivider.h>
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
	[self setDividerOrientation:KTSplitViewDividerOrientation_Vertical];
	[self setDividerThickness:8];
	[self setDividerPosition:[self frame].size.width*.5 fromView:KTSplitViewFocusedViewFlag_FirstView];
	[[mFirstView styleManager] setBorderColor:[NSColor whiteColor]];
	[[mFirstView styleManager] setBorderWidth:1];
	[[mFirstView styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.8 alpha:1]];
	[[mSecondView styleManager] setBorderColor:[NSColor whiteColor]];
	[[mSecondView styleManager] setBorderWidth:1];
	[[mSecondView styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.8 alpha:1]];
	[super ibDidAddToDesignableDocument:theDocument];
}


- (NSView*)hitTest:(NSPoint)thePoint
{
	if(NSPointInRect([self convertPoint:thePoint fromView:nil], [mDivider frame]))
	{
		if([[NSApp currentEvent] type]==NSLeftMouseDown)
			[mDivider mouseDown:[NSApp currentEvent]];
	}
	return [super hitTest:thePoint];
}

- (NSView*)ibDesignableContentView
{
	return nil;
}

- (BOOL)ibIsChildViewUserMovable:(NSView *)theChildView
{
	return NO;
}

- (BOOL)ibIsChildViewUserSizable:(NSView *)theChildView
{
	return NO;
}

- (NSArray*)ibDefaultChildren
{
	return [NSArray arrayWithObjects:mFirstView, mSecondView, nil];
}

@end
