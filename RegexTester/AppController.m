//
//  AppController.m
//  RegexTester
//
//  Created by Markus Teufel on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "NSBezierPath+MCAdditions.h"

@implementation AppController
@synthesize regexTextView;
@synthesize plainTextView, styleMenuStrings, checkboxesBackgroundView;
@synthesize usesNSRegularExpressionCaseInsensitive, usesNSRegularExpressionAllowCommentsAndWhitespace, usesNSRegularExpressionIgnoreMetacharacters, usesNSRegularExpressionDotMatchesLineSeparators, usesNSRegularExpressionAnchorsMatchLines, usesNSRegularExpressionUseUnixLineSeparators, usesNSRegularExpressionUseUnicodeWordBoundaries, highlightMode;


- (void)awakeFromNib
{
    NSFont* defaultFont = [NSFont fontWithName:@"Inconsolata" size:16];
    
    NSData* colorData = [[NSUserDefaults standardUserDefaults] dataForKey:@"highlightColor"];
    if (colorData != nil)
        highlightColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
    else
        highlightColor = NSColor.redColor;
    
    NSData* fontData = [[NSUserDefaults standardUserDefaults] dataForKey:@"highlightFont"];
    if (fontData != nil)
        highlightFont = (NSFont *)[NSUnarchiver unarchiveObjectWithData:fontData];
    else
        highlightFont = defaultFont;
    
    NSData* otherColorData = [[NSUserDefaults standardUserDefaults] dataForKey:@"otherColor"];
    if (otherColorData != nil)
        otherColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:otherColorData];
    else
        otherColor = NSColor.blackColor;
    
    NSData* otherFontData = [[NSUserDefaults standardUserDefaults] dataForKey:@"otherFont"];
    if (otherFontData != nil)
        otherFont = (NSFont *)[NSUnarchiver unarchiveObjectWithData:otherFontData];
    else
        otherFont = defaultFont;
    
    self.styleMenuStrings = @[@"Highlight",@"Other",@"Regex"];
    
    [regexTextView.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:@"e"]];
    [plainTextView.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:@"regex tester"]];
    [regexTextView setFont:otherFont];
    [plainTextView setFont:otherFont];
    
    [[NSColorPanel sharedColorPanel] setColor:highlightColor];
    [[NSColorPanel sharedColorPanel] setTarget:self];
    [[NSColorPanel sharedColorPanel] setAction:@selector(colorPanelColorDidChange:)];
    [[NSFontManager sharedFontManager] setTarget:self];
    [[NSFontManager sharedFontManager] setAction:@selector(changeFont:)];
    
    self.checkboxesBackgroundView.wantsLayer = YES;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.checkboxesBackgroundView.layer.contents = [NSImage imageWithSize:self.checkboxesBackgroundView.frame.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
            
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dstRect xRadius: 5.0 yRadius: 5.0];
            
            [NSGraphicsContext saveGraphicsState];
            
            // Draw backgound
            NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.9] endingColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.0]];
            [gradient drawInBezierPath:path angle:90.0];
            
            // Inner Glow/Shadow
            NSShadow *innerGlow = [[NSShadow alloc] init];
            [innerGlow setShadowBlurRadius:path.bounds.size.height / 8];
            [innerGlow setShadowOffset:NSMakeSize(0.0, -1.0)];
            [innerGlow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.3]];
            
            [path fillWithInnerShadow:innerGlow];
            
            // Draw border
            [[NSColor colorWithDeviceWhite:0.1 alpha:1.0] set];
            [path stroke];
            
            [NSGraphicsContext restoreGraphicsState];
            
            return YES;
        }];
    });
}

- (IBAction)openHelp:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://developer.apple.com/library/IOs/#documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)textDidChange:(NSNotification *)aNotification
{
    NSLog(@"goil update");
    
    
    NSString *regularExpressionString = regexTextView.textStorage.string;
    NSString *textString = plainTextView.textStorage.string;
    NSMutableAttributedString *attrString = [plainTextView.attributedString mutableCopy];
    
    NSError *error = NULL;
    regex = [NSRegularExpression regularExpressionWithPattern:regularExpressionString
                                                      options:[self options]
                                                        error:&error];

    assert(otherFont != nil);
    assert(otherColor != nil);
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:otherColor
                       range:NSMakeRange(0, textString.length)];
    [attrString addAttribute:NSFontAttributeName value:otherFont range:NSMakeRange(0, textString.length)];
    
    [regex enumerateMatchesInString:textString options:0 range:NSMakeRange(0, [textString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        NSRange matchRange = [match range];
        [attrString addAttribute:NSForegroundColorAttributeName value:highlightColor range:matchRange];
        [attrString addAttribute:NSFontAttributeName value:highlightFont range:matchRange];
    }];
    
    [plainTextView.textStorage setAttributedString:attrString];
}


- (NSRegularExpressionOptions)options
{
    NSRegularExpressionOptions options = 0;
    
    if (usesNSRegularExpressionCaseInsensitive)
        options |= NSRegularExpressionCaseInsensitive;
    if (usesNSRegularExpressionAllowCommentsAndWhitespace)
        options |= NSRegularExpressionAllowCommentsAndWhitespace;
    if (usesNSRegularExpressionIgnoreMetacharacters)
        options |= NSRegularExpressionIgnoreMetacharacters;
    if (usesNSRegularExpressionDotMatchesLineSeparators)
        options |= NSRegularExpressionDotMatchesLineSeparators;
    if (usesNSRegularExpressionAnchorsMatchLines)
        options |= NSRegularExpressionAnchorsMatchLines;
    if (usesNSRegularExpressionUseUnixLineSeparators)
        options |= NSRegularExpressionUseUnixLineSeparators;
    if (usesNSRegularExpressionUseUnicodeWordBoundaries)
        options |= NSRegularExpressionUseUnicodeWordBoundaries;
    
    return options;
}

- (IBAction)changeFont:(id)sender
{    
    if (self.highlightMode)
    {
        highlightFont = [sender convertFont:highlightFont];
    }
    else
    {
        otherFont = [sender convertFont:highlightFont];
    }
    [self textDidChange:nil];
}

- (IBAction)colorPanelColorDidChange:(NSColorPanel*)theColorPanel;
{
    if (self.highlightMode)
    {
        highlightColor = (NSColor*)theColorPanel.color;
        NSData* colorData = [NSArchiver archivedDataWithRootObject:highlightColor];
        [NSUserDefaults.standardUserDefaults setObject:colorData forKey:@"highlightColor"];
    }
    else
    {
        otherColor = (NSColor*)theColorPanel.color;
        NSData* colorData = [NSArchiver archivedDataWithRootObject:otherColor];
        [NSUserDefaults.standardUserDefaults setObject:colorData forKey:@"otherColor"];
    }
    [self textDidChange:nil];
}


@end
