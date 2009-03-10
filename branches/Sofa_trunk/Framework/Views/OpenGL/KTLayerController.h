//
//  KTOpenGLLayerController.h
//  KTUIKit
//
//  Created by Cathy on 27/02/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTController.h"

@class KTViewController;

@interface KTLayerController : NSResponder <KTController>
{
	KTViewController *		wViewController;
	NSMutableArray *		mSubcontrollers;
	id						mLayer;
	id						wRepresentedObject;
}

@property (readwrite, assign) KTViewController * viewController;
@property (readwrite, retain) NSMutableArray * subcontrollers;
@property (readwrite, retain) id layer;
@property (readwrite, assign) id representedObject;

+ (id)layerControllerWithViewController:(KTViewController*)theViewController;
- (id)initWithViewController:(KTViewController*)theViewController;


// layer controller hierarchy API
- (void)addSubcontroller:(KTLayerController*)theSubcontroller;
- (void)removeSubcontroller:(KTLayerController*)theSubcontroller;

- (NSArray *)descendants;

@end
