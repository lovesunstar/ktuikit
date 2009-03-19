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
	KTViewController *		wViewController;
}

@property (readwrite, retain) NSString * label;
@property (readwrite, retain) id identifier;
@property (readwrite, assign) KTTabViewController * tabViewController;
@property (readwrite, assign) KTViewController * viewController;
@end
