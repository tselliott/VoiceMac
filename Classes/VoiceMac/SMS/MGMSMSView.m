//
//  MGMSMSView.m
//  VoiceMac
//
//  Created by Mr. Gecko on 8/27/10.
//  Copyright (c) 2011 Mr. Gecko's Media (James Coleman). http://mrgeckosmedia.com/
//
//  Permission to use, copy, modify, and/or distribute this software for any purpose
//  with or without fee is hereby granted, provided that the above copyright notice
//  and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
//  REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT,
//  OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
//  DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
//  ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

#import "MGMSMSView.h"
#import "MGMSMSMessageView.h"
#import "MGMVoiceUser.h"
#import "MGMController.h"
#import <VoiceBase/VoiceBase.h>

@implementation MGMSMSView
+ (id)viewWithMessageView:(MGMSMSMessageView *)theMessageView {
	return [[[self alloc] initWithMessageView:theMessageView] autorelease];
}
- (id)initWithMessageView:(MGMSMSMessageView *)theMessageView {
	if ((self = [super initWithFrame:NSMakeRect(0, 0, 100, 40)])) {
		messageView = theMessageView;
		[self setToolTip:[[messageView messageInfo] objectForKey:MGMTInName]];
		NSRect frameRect = [self frame];
		photoView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, frameRect.size.height, frameRect.size.height)];
		[photoView setRefusesFirstResponder:YES];
		[self addSubview:photoView];
		NSData *photoData = [[[messageView instance] contacts] photoDataForNumber:[[messageView messageInfo] objectForKey:MGMIPhoneNumber]];
		if (photoData==nil) {
			[photoView setImage:[[[NSImage alloc] initWithContentsOfFile:[[[(MGMVoiceUser *)[[messageView instance] delegate] controller] themeManager] incomingIconPath]] autorelease]];
		} else {
			[photoView setImage:[[[NSImage alloc] initWithData:photoData] autorelease]];
		}
		read = NO;
		int size = 12;
		nameField = [[NSTextField alloc] initWithFrame:NSMakeRect(frameRect.size.height+4, (frameRect.size.height/2)-4, frameRect.size.width-(frameRect.size.height+20), size)];
		[nameField setEditable:NO];
		[nameField setSelectable:NO];
		[nameField setBezeled:NO];
		[nameField setBordered:NO];
		[nameField setDrawsBackground:NO];
		[nameField setFont:[NSFont boldSystemFontOfSize:10]];
		[[nameField cell] setLineBreakMode:NSLineBreakByTruncatingTail];
		[self addSubview:nameField];
		[nameField setStringValue:[[messageView messageInfo] objectForKey:MGMTInName]];
		
		closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(frameRect.size.width-14, (frameRect.size.height/2)-6, 14, 14)];
		[closeButton setButtonType:NSMomentaryChangeButton];
		[closeButton setBezelStyle:NSRegularSquareBezelStyle];
		[closeButton setBordered:NO];
		[closeButton setImagePosition:NSImageOnly];
		[closeButton setImage:[NSImage imageNamed:@"Close"]];
		[closeButton setAlternateImage:[NSImage imageNamed:@"ClosePressed"]];
		[closeButton setTarget:messageView];
		[closeButton setAction:@selector(close:)];
		[self addSubview:closeButton];
	}
	return self;
}
- (void)dealloc {
	[photoView release];
	[nameField release];
	[closeButton release];
	[super dealloc];
}

- (void)setRead:(BOOL)isRead {
	read = isRead;
	[nameField setFont:[NSFont boldSystemFontOfSize:(isRead ? 10 : 12)]];
	[self resizeSubviewsWithOldSize:[self frame].size];
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize {
	[super resizeSubviewsWithOldSize:oldBoundsSize];
	NSRect frameRect = [self frame];
	[photoView setFrame:NSMakeRect(0, 0, frameRect.size.height, frameRect.size.height)];
	int size = 0;
	if (read)
		size = 12;
	else
		size = 14;
	[nameField setFrame:NSMakeRect(frameRect.size.height+4, (frameRect.size.height/2)-4, frameRect.size.width-(frameRect.size.height+20), size)];
	[closeButton setFrame:NSMakeRect(frameRect.size.width-14, (frameRect.size.height/2)-6, 14, 14)];
}
- (void)setFontColor:(NSColor *)theColor {
	[nameField setTextColor:theColor];
}
@end