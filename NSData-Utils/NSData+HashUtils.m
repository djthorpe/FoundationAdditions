
#import "NSData+HashUtils.h"
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/bio.h>

@implementation NSData (HashUtils)

-(NSData* )md5Digest {
  // compute an MD5 digest.
  EVP_MD_CTX mdctx;
  unsigned char md_value[EVP_MAX_MD_SIZE];
  unsigned int md_len;
  EVP_DigestInit(&mdctx, EVP_md5());
  EVP_DigestUpdate(&mdctx, [self bytes], [self length]);
  EVP_DigestFinal(&mdctx, md_value, &md_len);
  return [NSData dataWithBytes: md_value length: md_len];
}

-(NSData* )sha1Digest {
  // compute an SHA1 digest.
  EVP_MD_CTX mdctx;
  unsigned char md_value[EVP_MAX_MD_SIZE];
  unsigned int md_len;
  EVP_DigestInit(&mdctx, EVP_sha1());
  EVP_DigestUpdate(&mdctx, [self bytes], [self length]);
  EVP_DigestFinal(&mdctx, md_value, &md_len);
  return [NSData dataWithBytes: md_value length: md_len];
}

-(NSString* )md5Hash {
  NSData* theDigest = [self md5Digest];
  NSMutableString* theString = [NSMutableString stringWithCapacity:([theDigest length]*2)];
  const unsigned char* theBytes = (const unsigned char* )[theDigest bytes];
  for(unsigned int i = 0; i < [theDigest length]; i++) {
    [theString appendFormat:@"%02X",theBytes[i]];
  }
  return theString;
}

-(NSString* )sha1Hash {
  NSData* theDigest = [self sha1Digest];
  NSMutableString* theString = [NSMutableString stringWithCapacity:([theDigest length]*2)];
  const unsigned char* theBytes = (const unsigned char* )[theDigest bytes];
  for(unsigned int i = 0; i < [theDigest length]; i++) {
    [theString appendFormat:@"%02X",theBytes[i]];
  }
  return theString;
}


// next two methods from here:
// http://www.cocoadev.com/index.pl?BaseSixtyFour

-(NSString* )encodeBase64 {
  return [self encodeBase64WithNewlines:YES];
}

-(NSString* )encodeBase64WithNewlines:(BOOL)encodeWithNewlines {
  // Create a memory buffer which will contain the Base64 encoded string
  BIO * mem = BIO_new(BIO_s_mem());
  
  // Push on a Base64 filter so that writing to the buffer encodes the data
  BIO * b64 = BIO_new(BIO_f_base64());
  if (!encodeWithNewlines)
    BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
  mem = BIO_push(b64, mem);
  
  // Encode all the data
  BIO_write(mem, [self bytes], [self length]);
  BIO_flush(mem);
  
  // Create a new string from the data in the memory buffer
  char * base64Pointer;
  long base64Length = BIO_get_mem_data(mem, &base64Pointer);
  NSString * base64String = [NSString stringWithCString: base64Pointer length: base64Length];
  
  // Clean up and go home
  BIO_free_all(mem);
  return base64String;
}

@end

