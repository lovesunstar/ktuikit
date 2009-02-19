//
//  KTOpenGLView.h
//  KTUIKit
//
//  Created by Cathy on 16/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <OpenGL/glext.h>


#import "KTViewProtocol.h"
#import "KTLayoutManager.h"
#import "KTStyleManager.h"

@class KTOpenGLLayer;

@interface KTOpenGLView : NSOpenGLView <KTView>
{
	KTLayoutManager *			mLayoutManager;
	KTStyleManager *			mStyleManager;
	NSString *					mLabel;
	KTOpenGLLayer *				mOpenGLLayer;
}

@property (readwrite, retain) KTOpenGLLayer * openGLLayer;

+ (NSOpenGLPixelFormat*)defaultPixelFormat;
- (void)drawInContext:(NSOpenGLContext*)theContext;



@end
