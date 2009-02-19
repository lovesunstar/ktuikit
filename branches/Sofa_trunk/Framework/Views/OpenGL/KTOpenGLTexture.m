//
//  KTOpenGLTexture.m
//  KTUIKit
//
//  Created by Cathy on 19/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
	[self deleteTexture];
	[super dealloc];
}



//----------------------------------------------------------------------------------------
//	createTextureFromNSBitmapImageRep
//----------------------------------------------------------------------------------------
- (void)createTextureFromNSBitmapImageRep:(NSBitmapImageRep*)theNSBitmapImageRep
{
	if (	mTextureName == 0
		&& theNSBitmapImageRep != nil) 
	{
	
		mBitmapSource = [theNSBitmapImageRep retain];
		
		BOOL				aHasAlpha;
		GLenum				aFormat1;
		GLenum				aFormat2;
		GLenum				aType;
		NSInteger			aSamplesPerPixel;
		unsigned char *		aBitmapData;
		
		
		aBitmapData = [theNSBitmapImageRep bitmapData];
		mOriginalPixelsWide = [theNSBitmapImageRep pixelsWide];
		mOriginalPixelsHigh = [theNSBitmapImageRep pixelsHigh];

		aHasAlpha = [theNSBitmapImageRep hasAlpha];
		aFormat1 = aHasAlpha ? GL_RGBA8 : GL_RGB8;
		aFormat2 = aHasAlpha ? GL_RGBA : GL_RGB;
		aSamplesPerPixel = aHasAlpha ? 4 : 3;
		
		aType = aHasAlpha ? ARGB_IMAGE_TYPE : GL_UNSIGNED_BYTE;
		
		glGenTextures(1, &mTextureName);
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, mTextureName);
		
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_CACHED_APPLE);
		glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, GL_TRUE);
		glPixelStorei(GL_UNPACK_ALIGNMENT, ([theNSBitmapImageRep bitsPerSample] >> aSamplesPerPixel));
		glPixelStorei(GL_UNPACK_ROW_LENGTH, ([theNSBitmapImageRep bytesPerRow] / ([theNSBitmapImageRep bitsPerPixel]  >> aSamplesPerPixel)));
		
		glTexImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, aFormat1, mOriginalPixelsWide, mOriginalPixelsHigh, 0, aFormat2, aType, aBitmapData);		
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
		
	}

}



//----------------------------------------------------------------------------------------
//	drawInRect:alpha
//----------------------------------------------------------------------------------------
- (void)drawInRect:(NSRect)theRect alpha:(CGFloat)theAlpha
{
	if( mTextureName == 0 )
		return;
		
	float aTextureWidth = mOriginalPixelsWide;
	float aTextureHeight = mOriginalPixelsHigh;
	float aTextureXPos = 0;
	float aTextureYPos = 0;
	
	float aDrawingWidth = floor(theRect.size.width);
	float aDrawingHeight = floor(theRect.size.height);
	
	float anXPosition = floor(theRect.origin.x);
	float aYPosition = floor(theRect.origin.y);

	glColor4f(1.0, 1.0, 1.0, theAlpha);
	glEnable(GL_TEXTURE_RECTANGLE_EXT);
	glBindTexture( GL_TEXTURE_RECTANGLE_EXT, mTextureName );
	
	glPushMatrix();	
	
	glTranslatef(anXPosition, aYPosition, 0);
	
	glBegin( GL_QUADS );
		glTexCoord2f(aTextureXPos, aTextureYPos);			glVertex3f(aTextureXPos, aDrawingHeight, 0);
		glTexCoord2f(aTextureWidth, aTextureYPos);			glVertex3f(aDrawingWidth, aDrawingHeight, 0);
		glTexCoord2f(aTextureWidth, aTextureHeight);		glVertex3f(aDrawingWidth, aTextureYPos, 0);
		glTexCoord2f(aTextureXPos, aTextureHeight);			glVertex3f(aTextureXPos, aTextureYPos, 0);
	glEnd();
	
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
	glDisable(GL_TEXTURE_RECTANGLE_EXT);
	
	glPopMatrix();


}


//----------------------------------------------------------------------------------------
//	deleteTexture
//----------------------------------------------------------------------------------------
- (void)deleteTexture
{
	if(mTextureName)
	{
		glDeleteTextures(1,&mTextureName);
		mTextureName = 0;
	}
	[mBitmapSource release];
	mBitmapSource = nil;	
}



@end
