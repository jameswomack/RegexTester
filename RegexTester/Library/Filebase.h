//
//  Filebase.h
//  RegexTester
//
//  Created by James Womack on 2/7/13.
//
//



#pragma mark interface

#pragma mark -types

typedef struct filebase_t {
    NSString* (* bundlePath)();
    NSArray* (* bundleContents)();
    NSArray* (* contents)();
} Filebase;

typedef enum {
    FilebaseErrorCodeItemNotFound = 8880,
    FilebaseErrorCodeItemTypeUnexpected = 8881
} FilebaseErrorCodes;


#pragma mark -strings

extern NSString* const FilebaseErrorCodeItemNotFoundString;
extern NSString* const FilebaseErrorCodeItemTypeUnexpectedString;

#pragma mark -functions

NSString* _bundlePath_(NSString* aPath);
NSArray* _bundleContents_(NSString* aPath);
NSArray* _contents_(NSString* aPath);

Filebase* initializeFilebase(void);



