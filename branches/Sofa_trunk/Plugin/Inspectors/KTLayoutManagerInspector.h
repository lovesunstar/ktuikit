//
//  KTViewInspector.h
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

@class KTLayoutManagerControl;
@class KTView;
@interface KTLayoutManagerInspector : IBInspector 
{
	IBOutlet NSTextField *		oLabel;
	IBOutlet KTView *			oRow1View;
	// Frame
	IBOutlet NSTextField *		oXPosition;
	IBOutlet NSTextField *		oYPosition;
	IBOutlet NSTextField *		oWidth;
	IBOutlet NSTextField *		oHeight;
	IBOutlet NSButton *			oFillWidthButton;
	IBOutlet NSButton *			oFillHeightButton;
	IBOutlet NSButton *			oCenterVerticallyButton;
	IBOutlet NSButton *			oCenterHorizontallyButton;
	IBOutlet NSButton *			oFlushTopButton;
	IBOutlet NSButton *			oFlushBottomButton;
	IBOutlet NSButton *			oFlushRightButton;
	IBOutlet NSButton *			oFlushLeftButton;
	
	// Autoresizing
	IBOutlet KTLayoutManagerControl *		oLayoutControl;
}

- (IBAction)setXPosition:(id)theSender;
- (IBAction)setYPosition:(id)theSender;
- (IBAction)setWidth:(id)theSender;
- (IBAction)setHeight:(id)theSender;

- (IBAction)fillCurrentWidth:(id)theSender;
- (IBAction)fillCurrentHeight:(id)theSender;
- (IBAction)centerHorizontally:(id)theSender;
- (IBAction)centerVertically:(id)theSender;
- (IBAction)flushTop:(id)theSender;
- (IBAction)flushBottom:(id)theSender;
- (IBAction)flushLeft:(id)theSender;
- (IBAction)flushRight:(id)theSender;

@end
