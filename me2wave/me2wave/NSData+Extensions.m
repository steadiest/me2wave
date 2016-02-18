#import <Foundation/Foundation.h>
#import "NSData+Extensions.h"

static const char basis_64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

void nb64ChunkFor3Characters(char *buf, const char *inBuf, int theLength)
{
	if (theLength >= 3)
    {
		buf[0] = basis_64[inBuf[0]>>2 & 0x3F];
		buf[1] = basis_64[(((inBuf[0] & 0x3)<< 4) | ((inBuf[1] & 0xF0) >> 4)) & 0x3F];
		buf[2] = basis_64[(((inBuf[1] & 0xF) << 2) | ((inBuf[2] & 0xC0) >>6)) & 0x3F];
		buf[3] = basis_64[inBuf[2] & 0x3F];
    }
	else if(theLength == 2)
    {
		buf[0] = basis_64[inBuf[0]>>2 & 0x3F];
		buf[1] = basis_64[(((inBuf[0] & 0x3)<< 4) | ((inBuf[1] & 0xF0) >> 4)) & 0x3F];
		buf[2] = basis_64[(((inBuf[1] & 0xF) << 2) | ((0 & 0xC0) >>6)) & 0x3F];
		buf[3] = '=';
    }
	else
    {
		buf[0] = basis_64[inBuf[0]>>2 & 0x3F];
		buf[1] = basis_64[(((inBuf[0] & 0x3)<< 4) | ((0 & 0xF0) >> 4)) & 0x3F];
		buf[2] = '=';
		buf[3] = '=';
    }
}


//---------------------------------------------------------------------------------------
@implementation NSData(EDExtensions)
//---------------------------------------------------------------------------------------

- (NSData *) encodeBase64
{
	return [self encodeBase64WithLineLength:0];
}
- (NSData *) encodeBase64WithLineLength: (int) theLength
{
	const char *inBytes = [self bytes];
	const char *inBytesPtr = inBytes;
	int inLength = [self length];
	
	char *outBytes = malloc(sizeof(char)*inLength*2);
	char *outBytesPtr = outBytes;
	
	int numWordsPerLine = theLength/4;
	int wordCounter = 0;
	
	// We memset 0 our buffer so with are sure to not have
	// any garbage in it.
	memset(outBytes, 0, sizeof(char)*inLength*2);
	
	while (inLength > 0)
    {
		nb64ChunkFor3Characters(outBytesPtr, inBytesPtr, inLength);
		outBytesPtr += 4;
		inBytesPtr += 3;
		inLength -= 3;
		
		wordCounter ++;
		
		if (theLength && wordCounter == numWordsPerLine)
		{
			wordCounter = 0;
			*outBytesPtr = '\n';
			outBytesPtr++;
		}
	}
	
	return [[[NSData alloc] initWithBytesNoCopy: outBytes length: (outBytesPtr-outBytes)] autorelease];
}
//---------------------------------------------------------------------------------------
@end
//---------------------------------------------------------------------------------------