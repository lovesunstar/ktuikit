//
//  TestAppWindowController.m
//  KTUIKit
//
//  Created by Cathy Shive on 11/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TestAppWindowController.h"
#import "GradientPickerViewController.h"

@implementation TestAppWindowController
- (void)windowDidLoad
{
//	GradientPickerViewController * aGradientPickerController = [GradientPickerViewController viewControllerWithWindowController:self];
//	[self addViewController:aGradientPickerController];
//	
//	id aGradientPickerView = [aGradientPickerController view];
//	[aGradientPickerView setFrame:[[[self window]contentView]frame]];
//	[aGradientPickerView setAutoresizingMask:(NSViewWidthSizable|NSViewHeightSizable)];
//	[[self window] setContentView:aGradientPickerView];
//	[[aGradientPickerView viewLayoutManager] refreshLayout];


	KTView * aWindowContentView = [[[KTView alloc] initWithFrame:[[[self window] contentView] frame]] autorelease];
	[aWindowContentView setAutoresizingMask:(NSViewWidthSizable|NSViewHeightSizable)];
	[[self window] setContentView:aWindowContentView];
	[[aWindowContentView styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.8 alpha:1]];
	
	
	KTView * aView1 = [[[KTView alloc] initWithFrame:NSZeroRect] autorelease];
	[[aView1 styleManager] setBorderColor:[NSColor greenColor]];
	[[aView1 styleManager] setBorderWidth:1];
	[[aView1 styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
	[[aView1 viewLayoutManager] setHeightType:KTSizeFill];
	[[aView1 viewLayoutManager] setWidthType:KTSizeFill];
	[[aView1 viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionFloatRight];
	[[aView1 viewLayoutManager] setMarginTop:0 right:5 bottom:0 left:5];
	[aWindowContentView addSubview:aView1];
	
	KTView * aView2 = [[[KTView alloc] initWithFrame:NSMakeRect(0, 0, 100, 0)] autorelease];
	[[aView2 styleManager] setBorderColor:[NSColor greenColor]];
	[[aView2 styleManager] setBorderWidth:1];
	[[aView2 styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
	[[aView2 viewLayoutManager] setHeightType:KTSizeFill];
	[[aView2 viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionFloatRight];
	[[aView2 viewLayoutManager] setMarginTop:0 right:5 bottom:0 left:5];
	[aWindowContentView addSubview:aView2];
		
	KTView * aView3 = [[[KTView alloc] initWithFrame:NSZeroRect] autorelease];
	[[aView3 styleManager] setBorderColor:[NSColor greenColor]];
	[[aView3 styleManager] setBorderWidth:1];
	[[aView3 styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
	[[aView3 viewLayoutManager] setHeightType:KTSizeFill];
	[[aView3 viewLayoutManager] setWidthType:KTSizeFill];
	[[aView3 viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionFloatRight];
	[[aView3 viewLayoutManager] setMarginTop:0 right:5 bottom:0 left:5];
	[aWindowContentView addSubview:aView3];	
	
	KTView * aView4 = [[[KTView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)] autorelease];
	[[aView4 styleManager] setBorderColor:[NSColor greenColor]];
	[[aView4 styleManager] setBorderWidth:1];
	[[aView4 styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
	[[aView4 viewLayoutManager] setHeightType:KTSizeFill];
	[[aView4 viewLayoutManager] setWidthPercentage:.5];
	[[aView4 viewLayoutManager] setWidthType:KTSizePercentage];
	[[aView4 viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionFloatRight];
	[[aView4 viewLayoutManager] setMarginTop:0 right:5 bottom:0 left:5];
	[aWindowContentView addSubview:aView4];

	KTView * aView5 = [[[KTView alloc] initWithFrame:NSZeroRect] autorelease];
	[[aView5 styleManager] setBorderColor:[NSColor greenColor]];
	[[aView5 styleManager] setBorderWidth:1];
	[[aView5 styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
	[[aView5 viewLayoutManager] setHeightType:KTSizeFill];
	[[aView5 viewLayoutManager] setWidthType:KTSizeFill];
	[[aView5 viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionFloatRight];
	[[aView5 viewLayoutManager] setMarginTop:0 right:5 bottom:0 left:5];
	[aWindowContentView addSubview:aView5];	
	
	
	KTView * aView6 = [[[KTView alloc] initWithFrame:NSZeroRect] autorelease];
	[[aView6 styleManager] setBorderColor:[NSColor greenColor]];
	[[aView6 styleManager] setBorderWidth:1];
	[[aView6 styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
	[[aView6 viewLayoutManager] setHeightType:KTSizeFill];
	[[aView6 viewLayoutManager] setWidthType:KTSizeFill];
	[[aView6 viewLayoutManager] setHorizontalPositionType:KTHorizontalPositionFloatRight];
	[[aView6 viewLayoutManager] setMarginTop:0 right:5 bottom:0 left:5];
	[aWindowContentView addSubview:aView6];	
	
	
	[[aWindowContentView viewLayoutManager] refreshLayout];
	
}	

@end
