//
//  KTTabItem.h
//  KTUIKit
//
//  Created by Cathy on 18/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KTTabViewController;
@class KTViewController;

@interface KTTabItem : NSObject 
{
	NSString *				mLabel;
	id						mIdentifier;
	KTTabViewController *	wTabViewController;
	KTViewController *		mViewController;
}
- (id)initWithViewController:(KTViewController*)theViewController;

@property (readwrite, retain) NSString * label;
@property (readwrite, assign) id identifier;
@property (readwrite, assign) KTTabViewController * tabViewController;
@property (readwrite, assign) KTViewController * viewController;

@end
