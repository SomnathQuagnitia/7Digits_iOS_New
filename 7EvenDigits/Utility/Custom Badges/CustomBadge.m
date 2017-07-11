/*
 CustomBadge.m
 
 *** Description: ***
 With this class you can draw a typical iOS badge indicator with a custom text on any view.
 Please use the allocator customBadgeWithString to create a new badge.
 In this version you can modfiy the color inside the badge (insetColor),
 the color of the frame (frameColor), the color of the text and you can
 tell the class if you want a frame around the badge.
 
 *** License & Copyright ***
 Created by Sascha Marc Paulus www.spaulus.com on 04/2011. Version 2.0
 This tiny class can be used for free in private and commercial applications.
 Please feel free to modify, extend or distribution this class. 
 If you modify it: Please send me your modified version of the class.
 A commercial distribution of this class is not allowed.
 
 I would appreciate if you could refer to my website www.spaulus.com if you use this class.
 
 If you have any questions please feel free to contact me (open@spaulus.com).
 */


#import "CustomBadge.h"

@interface CustomBadge()
- (void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect;
- (void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect;
@end

@implementation CustomBadge

@synthesize badgeText;
@synthesize badgeTextColor;
@synthesize badgeInsetColor;
@synthesize badgeFrameColor;
@synthesize badgeFrame;
@synthesize badgeCornerRoundness;
@synthesize badgeScaleFactor;
@synthesize badgeShining;

#define badgeHeightWidth (IS_IPAD ? 40 : 20)

// I recommend to use the allocator customBadgeWithString
- (id) initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining{
    @try {
        self = [super initWithFrame:CGRectMake(-10, -10, badgeHeightWidth, badgeHeightWidth)];
        if(self!=nil) {
            self.contentScaleFactor = [[UIScreen mainScreen] scale];
            self.backgroundColor = [UIColor clearColor];
            self.badgeText = badgeString;
            self.badgeTextColor = [UIColor whiteColor];
            self.badgeFrame = YES;
            self.badgeFrameColor = [UIColor whiteColor];
            self.badgeInsetColor = [UIColor redColor];
            self.badgeCornerRoundness = 0.4;
            self.badgeScaleFactor = scale;
            self.badgeShining = shining;
            [self autoBadgeSizeWithString:badgeString];		
        }
        return self;
    } @catch (NSException *ex) {
	}
}


// I recommend to use the allocator customBadgeWithString
- (id) initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining {
    @try {
        self = [super initWithFrame:CGRectMake(-10,-10, badgeHeightWidth, badgeHeightWidth)];
        if(self!=nil) {
            self.contentScaleFactor = [[UIScreen mainScreen] scale];
            self.backgroundColor = [UIColor clearColor];
            self.badgeText = badgeString;
            self.badgeTextColor = stringColor;
            self.badgeFrame = badgeFrameYesNo;
            self.badgeFrameColor = frameColor;
            self.badgeInsetColor = insetColor;
            self.badgeCornerRoundness = 0.40;
            self.badgeScaleFactor = scale;
            self.badgeShining = shining;
            [self autoBadgeSizeWithString:badgeString];
        }
        return self;
    } @catch (NSException *ex) {
	}
}



// Use this method if you want to change the badge text after the first rendering 
- (void) autoBadgeSizeWithString:(NSString *)badgeString{
    @try {
        CGSize retValue;
        CGFloat rectWidth, rectHeight;
        CGSize stringSize = [badgeString sizeWithFont:[UIFont boldSystemFontOfSize:12]];
        CGFloat flexSpace;
        if ([badgeString length]>=2) {
            flexSpace = [badgeString length];
            rectWidth = 15 + (stringSize.width + flexSpace); rectHeight = badgeHeightWidth;
            retValue = CGSizeMake(rectWidth*badgeScaleFactor, rectHeight*badgeScaleFactor);
        } else {
            retValue = CGSizeMake(badgeHeightWidth*badgeScaleFactor, badgeHeightWidth*badgeScaleFactor);
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
        self.badgeText = badgeString;
        [self setNeedsDisplay];
    } @catch (NSException *ex) {
	}
}



// Creates a Badge with a given Text 
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString{
    @try {
        return [[self alloc] initWithString:badgeString withScale:1.0 withShining:YES];
    } @catch (NSException *ex) {
	}
}



// Creates a Badge with a given Text, Text Color, Inset Color, Frame (YES/NO) and Frame Color 
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining{
    @try {
        return [[self alloc] initWithString:badgeString withStringColor:stringColor withInsetColor:insetColor withBadgeFrame:badgeFrameYesNo withBadgeFrameColor:frameColor withScale:scale withShining:shining];
    } @catch (NSException *ex) {
	}
}




 

// Draws the Badge with Quartz
-(void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect{
    @try {
        CGContextSaveGState(context);
        
        CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
        CGFloat puffer = CGRectGetMaxY(rect)*0.10;
        CGFloat maxX = CGRectGetMaxX(rect) - puffer;
        CGFloat maxY = CGRectGetMaxY(rect) - puffer;
        CGFloat minX = CGRectGetMinX(rect) + puffer;
        CGFloat minY = CGRectGetMinY(rect) + puffer;
		
        CGContextBeginPath(context);
        CGContextSetFillColorWithColor(context, [self.badgeInsetColor CGColor]);
        CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
        CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
        CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
        CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
        CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
        
    } @catch (NSException *ex) {
	}
}


// Draws the Badge Shine with Quartz
-(void) drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect{
    @try {
        CGContextSaveGState(context);
        
        CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
        CGFloat puffer = CGRectGetMaxY(rect)*0.10;
        CGFloat maxX = CGRectGetMaxX(rect) - puffer;
        CGFloat maxY = CGRectGetMaxY(rect) - puffer;
        CGFloat minX = CGRectGetMinX(rect) + puffer;
        CGFloat minY = CGRectGetMinY(rect) + puffer;
        CGContextBeginPath(context);
        CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
        CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
        CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
        CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
        CGContextClip(context);
        
        
        size_t num_locations = 2;
        CGFloat locations[2] = { 0.0, 0.4 };
        CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };
        
        CGColorSpaceRef cspace;
        CGGradientRef gradient;
        cspace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
        
        CGPoint sPoint, ePoint;
        sPoint.x = 0;
        sPoint.y = 0;
        ePoint.x = 0;
        ePoint.y = maxY;
        CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);
        
        CGColorSpaceRelease(cspace);
        CGGradientRelease(gradient);
        
        CGContextRestoreGState(context);	
    } @catch (NSException *ex) {
	}
}



// Draws the Badge Frame with Quartz
-(void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect{
    @try {
        CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
        CGFloat puffer = CGRectGetMaxY(rect)*0.10;
        
        CGFloat maxX = CGRectGetMaxX(rect) - puffer;
        CGFloat maxY = CGRectGetMaxY(rect) - puffer;
        CGFloat minX = CGRectGetMinX(rect) + puffer;
        CGFloat minY = CGRectGetMinY(rect) + puffer;
        
        
        CGContextBeginPath(context);
        CGFloat lineSize = IS_IPAD ? 3 : 2;
        if(self.badgeScaleFactor>1) {
            lineSize += self.badgeScaleFactor*badgeHeightWidth / 100;
        }
        CGContextSetLineWidth(context, lineSize);
        CGContextSetStrokeColorWithColor(context, [self.badgeFrameColor CGColor]);
        CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
        CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
        CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
        CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    } @catch (NSException *ex) {
	}
}



- (void)drawRect:(CGRect)rect{
    @try {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self drawRoundedRectWithContext:context withRect:rect];
        if(self.badgeShining) {
            [self drawShineWithContext:context withRect:rect];
        }
        if (self.badgeFrame)  {
            [self drawFrameWithContext:context withRect:rect];
        }
        if ([self.badgeText length]>0) {
            [badgeTextColor set];
            CGFloat fontSize = IS_IPAD ? 16 : 10.5;
            CGFloat sizeOfFont = fontSize*badgeScaleFactor;
            if ([self.badgeText length]<2) {
                sizeOfFont += sizeOfFont*0.016;
            }
            UIFont *textFont = [UIFont boldSystemFontOfSize:sizeOfFont];
            CGSize textSize = [self.badgeText sizeWithFont:textFont];
            [self.badgeText drawAtPoint:CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2)) withFont:textFont];
        }
    } @catch (NSException *ex) {
	}
}

+ (void)getCustomBadgeWithY:(CGFloat)y gap:(CGFloat)gap badgeValue:(NSString *)badgeValue onView:(UIView *)view
{
    CustomBadge *badgeView = [CustomBadge customBadgeWithString:badgeValue
                                                withStringColor:[UIColor whiteColor]
                                                 withInsetColor:[UIColor redColor]
                                                 withBadgeFrame:YES
                                            withBadgeFrameColor:[UIColor whiteColor]
                                                      withScale:1.0
                                                    withShining:YES];
    CGFloat x = view.frame.size.width - badgeView.frame.size.width - gap;

    CGRect frameForbadgeView = CGRectMake(x, y, badgeView.frame.size.width, badgeView.frame.size.height);
    [badgeView setFrame:frameForbadgeView];
    [view addSubview:badgeView];
}

@end
