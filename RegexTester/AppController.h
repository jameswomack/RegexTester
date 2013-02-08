//
//  AppController.h
//  RegexTester
//
//  Created by Markus Teufel on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject
{
    NSRegularExpression *regex;
    BOOL usesNSRegularExpressionCaseInsensitive;
    BOOL usesNSRegularExpressionAllowCommentsAndWhitespace;
    BOOL usesNSRegularExpressionIgnoreMetacharacters;
    BOOL usesNSRegularExpressionDotMatchesLineSeparators;
    BOOL usesNSRegularExpressionAnchorsMatchLines;
    BOOL usesNSRegularExpressionUseUnixLineSeparators;
    BOOL usesNSRegularExpressionUseUnicodeWordBoundaries;
    BOOL highlightMode;
    NSColor* highlightColor;
    NSFont* highlightFont;
    NSColor* otherColor;
    NSFont* otherFont;
}

@property (unsafe_unretained) IBOutlet NSTextView *regexTextView;
@property (unsafe_unretained) IBOutlet NSTextView *plainTextView;
@property (unsafe_unretained) IBOutlet NSView *checkboxesBackgroundView;

@property BOOL usesNSRegularExpressionCaseInsensitive;
@property BOOL usesNSRegularExpressionAllowCommentsAndWhitespace;
@property BOOL usesNSRegularExpressionIgnoreMetacharacters;
@property BOOL usesNSRegularExpressionDotMatchesLineSeparators;
@property BOOL usesNSRegularExpressionAnchorsMatchLines;
@property BOOL usesNSRegularExpressionUseUnixLineSeparators;
@property BOOL usesNSRegularExpressionUseUnicodeWordBoundaries;
@property BOOL highlightMode;
@property (strong) NSArray* styleMenuStrings;

-(NSRegularExpressionOptions)options;

- (IBAction)colorPanelColorDidChange:(NSColorPanel*)theColorPanel;
- (IBAction)changeFont:(id)sender;

@end
