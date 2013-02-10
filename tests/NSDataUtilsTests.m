
#import <Foundation/Foundation.h>
#import "NSData+HashUtils.h"

NSData* createData(NSUInteger size) {
	NSMutableData* data = [[NSMutableData alloc] initWithLength:size];
	Byte* ptr = [data mutableBytes];
	for(NSUInteger i = 0; i < size; i++) {
		ptr[i] = random() % 256;
	}
	return data;
}

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		// create a 64kB data object
	    NSData* data = createData(64 * 1024);

		// return data signatures
	    NSLog(@"[data md5Digest] = %@",[data md5Digest]);
	    NSLog(@"[data md5Hash] = %@",[data md5Hash]);

	    NSLog(@"[data sha1Digest] = %@",[data sha1Digest]);
	    NSLog(@"[data sha1Hash] = %@",[data sha1Hash]);
		
		// create a smaller data object (64 bytes)
	    NSData* data2 = createData(64);
		
		// return data encoded in base64
	    NSLog(@"[data2 base64] = %@",[data2 encodeBase64WithNewlines:YES]);
	}
    return 0;
}

