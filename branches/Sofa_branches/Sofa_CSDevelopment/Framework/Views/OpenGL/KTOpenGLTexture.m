//
//  KTOpenGLTexture.m
//  KTUIKit
//
//  Created by Cathy on 19/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// Apple Docs: Techniques for working with texture data:
//http://developer.apple.com/documentation/graphicsimaging/Conceptual/OpenGL-MacProgGuide/opengl_texturedata/chapter_10_section_5.html#//apple_ref/doc/uid/TP40001987-CH407-SW28

#import "KTOpenGLTexture.h"
#if __BIG_ENDIAN__
	#define ARGB_IMAGE_TYPE GL_UNSIGNED_INT_8_8_8_8
#else
	#define ARGB_IMAGE_TYPE GL_UNSIGNED_INT_8_8_8_8_REV
#endif

@implementation KTOpenGLTexture
//----------------------------------------------------------------------------------------
//	init
//----------------------------------------------------------------------------------------
- (id)init
{
	if(self = [super init])
	{
		mTextureName = 0;
		mOriginalPixelsWide = 0;
		mOriginalPixelsHigh = 0;
		mBitmapSource = nil;
	}
	return self;
}

//----------------------------------------------------------------------------------------
//	dealloc
//----------------------------------------------------------------------------------------
- (void)dealloc
{
	//NSLog(@"%@ dealloc", self);
	[self performSelectorOnMainThread:@selector(deleteTexture) withObject:nil waitUntilDone:YES];
	[super dealloc];
}


//----------------------------------------------------------------------------------------
//	createTextureFromNSBitmapImageRep
//----------------------------------------------------------------------------------------
- (void)createTextureFromNSBitmapImageRep:(NSBitmapImageRep*)theNSBitmapImageRep openGLContext:(NSOpenGLContext*)theContext
{
	NSDictionary * anInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:theNSBitmapImageRep, @"NSBitmapImageRepInfoKey", theContext, @"NSOpenGLContextInfoKey", nil];
	[self performSelectorOnMainThread:@selector(uploadTextureWithTextureInfo:) withObject:anInfoDict waitUntilDone:YES];
	
}

//
////----------------------------------------------------------------------------------------
////	uploadTextureWithTextureInfo
////----------------------------------------------------------------------------------------
//- (void)uploadTextureWithTextureInfo:(NSDictionary*)theInfoDict
//{
//	NSOpenGLContext *	anOpenGLContext = [theInfoDict objectForKey:@"NSOpenGLContextInfoKey"];
//	NSBitmapImageRep *	anNSBitmapImageRep = [theInfoDict objectForKey:@"NSBitmapImageRepInfoKey"];
//	
//	if (	mTextureName == 0
//		&&	anNSBitmapImageRep != nil
//		&&	anOpenGLContext != nil) 
//	{
//		mOpenGLContext = [anOpenGLContext retain];
//		mBitmapSource = [anNSBitmapImageRep retain];
//		
//		[mOpenGLContext makeCurrentContext];
//		
//		GLenum				aFormat1;
//		GLenum				aFormat2;
//		GLenum				aType;
//		NSInteger			aSamplesPerPixel;
//		unsigned char *		aBitmapData;
//		
//		aBitmapData = [mBitmapSource bitmapData];
//		mOriginalPixelsWide = (GLuint)ceil([(NSBitmapImageRep*)mBitmapSource pixelsWide]);
//		mOriginalPixelsHigh = (GLuint)ceil([(NSBitmapImageRep*)mBitmapSource pixelsHigh]);
//		
//
//		
//		mHasAlpha = [mBitmapSource hasAlpha];
//		if([mBitmapSource bitsPerPixel]==8)
//		{
//			// gray scale image
//			aFormat1 = GL_LUMINANCE8;
//			aFormat2 = GL_LUMINANCE;
//		}
//		else
//		{
//			aFormat1 = mHasAlpha ? GL_RGBA8 : GL_RGB8;
//			aFormat2 = mHasAlpha ? GL_RGBA : GL_RGB;
//		}
//		
//		aSamplesPerPixel = ([mBitmapSource bitsPerPixel]/[mBitmapSource bitsPerSample]);
//		
//		aType = mHasAlpha ? ARGB_IMAGE_TYPE : GL_UNSIGNED_BYTE;
//		
////		NSLog(@"pixels wide: %d high:%d", mOriginalPixelsWide, mOriginalPixelsHigh);
////		NSLog(@"bits per sample: %d", [mBitmapSource bitsPerSample]);
////		NSLog(@"bytes per row: %d", [mBitmapSource bytesPerRow]);
////		NSLog(@"bits per pixels: %d", [mBitmapSource bitsPerPixel]);
////		NSLog(@"samples per pixel: %d", [mBitmapSource bitsPerPixel]/[mBitmapSource bitsPerSample]);
//		
//		
//		glGenTextures(1, &mTextureName);
//		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, mTextureName);
//		
//		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
//		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
//		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//		
//		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_CACHED_APPLE);
//		glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, GL_TRUE);
//		glPixelStorei(GL_UNPACK_ROW_LENGTH, mOriginalPixelsWide);//([mBitmapSource bytesPerRow] / ([mBitmapSource bitsPerPixel]  >> aSamplesPerPixel)));//([mBitmapSource bytesPerRow] / aSamplesPerPixel));//
//		
//		glTexImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, aFormat1, mOriginalPixelsWide, mOriginalPixelsHigh, 0, aFormat2, aType, aBitmapData);		
//		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
//	}
//}
//

//----------------------------------------------------------------------------------------
//	drawInRect:alpha
//----------------------------------------------------------------------------------------
- (void)drawInRect:(NSRect)theRect alpha:(CGFloat)theAlpha
{
	if( mTextureName == 0 )
		return;
		
	//NSLog(@"texture DRAW IN RECT x:%f y:%f w:%f h:%f", theRect.origin.x, theRect.origin.y, theRect.size.width, theRect.size.height);	
	[mOpenGLContext makeCurrentContext];
		
	GLuint aTextureWidth = mOriginalPixelsWide;
	GLuint aTextureHeight = mOriginalPixelsHigh;
	GLuint aTextureXPos = 0;
	GLuint aTextureYPos = 0;
	
	GLuint aDrawingWidth = (GLuint)ceil(theRect.size.width);
	GLuint aDrawingHeight = (GLuint)ceil(theRect.size.height);
	
	GLuint anXPosition = theRect.origin.x;
	GLuint aYPosition = theRect.origin.y;

	glColor4f(1.0, 1.0, 1.0, theAlpha);
	glEnable(GL_TEXTURE_RECTANGLE_EXT);
	glBindTexture( GL_TEXTURE_RECTANGLE_EXT, mTextureName);
	
	glPushMatrix();	
	glTranslatef(anXPosition, aYPosition, 0);
	glRotatef(0, 1, 0, 0);
	glRotatef(0, 0, 1, 0);
	glRotatef(0, 0, 0, 1);
//	glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
	glBegin( GL_QUADS );
		glTexCoord2i(aTextureXPos, aTextureYPos);			glVertex3i(aTextureXPos, aDrawingHeight, 0);
		glTexCoord2i(aTextureWidth, aTextureYPos);			glVertex3i(aDrawingWidth, aDrawingHeight, 0);
		glTexCoord2i(aTextureWidth, aTextureHeight);		glVertex3i(aDrawingWidth, aTextureYPos, 0);
		glTexCoord2i(aTextureXPos, aTextureHeight);			glVertex3i(aTextureXPos, aTextureYPos, 0);
	glEnd();
	
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
	glDisable(GL_TEXTURE_RECTANGLE_EXT);
	
	glPopMatrix();
}

//----------------------------------------------------------------------------------------
//	drawInRect:anchorPoint:alpha
//----------------------------------------------------------------------------------------
- (void)drawInRect:(NSRect)theRect anchorPoint:(NSPoint)theAnchorPoint alpha:(CGFloat)theAlpha
{
	if( mTextureName == 0 )
		return;
		
	[mOpenGLContext makeCurrentContext];
		
	CGFloat aTextureWidth = mOriginalPixelsWide;
	CGFloat aTextureHeight = mOriginalPixelsHigh;
	CGFloat aTextureXPos = 0;
	CGFloat aTextureYPos = 0;
	
	CGFloat aDrawingWidth = theRect.size.width;
	CGFloat aDrawingHeight = theRect.size.height;
	
	CGFloat anXPosition = theRect.origin.x;
	CGFloat aYPosition = theRect.origin.y;

	glColor4f(1.0, 1.0, 1.0, theAlpha);
	glEnable(GL_TEXTURE_RECTANGLE_EXT);
	glBindTexture( GL_TEXTURE_RECTANGLE_EXT, mTextureName);
	
	glPushMatrix();	
	glTranslatef(anXPosition, aYPosition, 0);
	
	glBegin( GL_QUADS );
		glTexCoord2i(aTextureXPos, aTextureYPos);			glVertex3i(aTextureXPos, aDrawingHeight, 0);
		glTexCoord2i(aTextureWidth, aTextureYPos);			glVertex3i(aDrawingWidth, aDrawingHeight, 0);
		glTexCoord2i(aTextureWidth, aTextureHeight);		glVertex3i(aDrawingWidth, aTextureYPos, 0);
		glTexCoord2i(aTextureXPos, aTextureHeight);			glVertex3i(aTextureXPos, aTextureYPos, 0);
	glEnd();
	
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
	glDisable(GL_TEXTURE_RECTANGLE_EXT);
	
	glPopMatrix();	
}

//----------------------------------------------------------------------------------------
//	size
//----------------------------------------------------------------------------------------
- (NSSize)size
{
	return NSMakeSize(mOriginalPixelsWide, mOriginalPixelsHigh);
}

//----------------------------------------------------------------------------------------
//	hasAlpha
//----------------------------------------------------------------------------------------
- (BOOL)hasAlpha
{
	return mHasAlpha;
}


//----------------------------------------------------------------------------------------
//	textureName
//----------------------------------------------------------------------------------------
- (GLuint)textureName
{
	return mTextureName;
}

//----------------------------------------------------------------------------------------
//	deleteTexture
//----------------------------------------------------------------------------------------
- (void)deleteTexture
{
	if(mTextureName)
	{
		[mOpenGLContext makeCurrentContext];
		glDeleteTextures(1,&mTextureName);
		mTextureName = 0;
	}
	[mBitmapSource release];
	mBitmapSource = nil;	
	[mOpenGLContext release];
	mOpenGLContext = nil;
}



@end