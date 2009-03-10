//
//  KTOpenGLTexture.h
//  KTUIKit
//
//  Created by Cathy on 19/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/glu.h>
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>


@interface KTOpenGLTexture : NSObject 
{
	@private
		GLuint				mTextureName;
		size_t				mOriginalPixelsWide;
		size_t				mOriginalPixelsHigh;
		id					mBitmapSource;
		NSOpenGLContext *	mOpenGLContext;
}

- (void)createTextureWithTextureInfo:(NSDictionary*)theTextureInfo;
- (void)createTextureFromNSBitmapImageRep:(NSBitmapImageRep*)theNSBitmapImageRep openGLContext:(NSOpenGLContext*)theContext;
- (void)drawInRect:(NSRect)theRect alpha:(CGFloat)theAlpha;
- (void)deleteTexture;
- (NSSize)size;
@end
