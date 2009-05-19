//
//  KTSplitViewInspector.h
//  KTUIKit
//
//  Created by Cathy on 15/05/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

@interface KTSplitViewInspector : IBInspector 
{
	IBOutlet NSColorWell *	mBackgroundColorWell;
	IBOutlet NSColorWell *	mFirstStrokeColorWell;
	IBOutlet NSColorWell *	mSecondStrokeColorWell;
}

- (IBAction)setOrientation:(id)theSender;
- (IBAction)setDividerThickness:(id)theSender;
- (IBAction)setDividerBackgroundColor:(id)theSender;
- (IBAction)setDividerFirstBorderColor:(id)theSender;
- (IBAction)setDividerSecondBorderColor:(id)theSender;
- (IBAction)setResizeBehavior:(id)theSender;

@end
