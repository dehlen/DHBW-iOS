//
//  JTCircleView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCircleView.h"

// http://stackoverflow.com/questions/17038017/ios-draw-filled-circles

@implementation JTCircleView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if(self.isTodayCircle) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
        CGContextFillRect(ctx, rect);
        
        rect = CGRectInset(rect, .5, .5);
        /* Draw a circle */
        // Get the contextRef
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        // Set the border width
        CGContextSetLineWidth(contextRef, 1.0);
        
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CGFloat redFill = 0.0, greenFill = 0.0, blueFill = 0.0, alphaFill = 0.0;
        [[UIColor whiteColor] getRed:&redFill green:&greenFill blue:&blueFill alpha:&alphaFill];

        // Set the circle fill color to WHITE
        CGContextSetRGBFillColor(contextRef, redFill,greenFill,blueFill,alphaFill);

        // Set the cicle border color to SELF.COLOR
        CGContextSetRGBStrokeColor(contextRef, red,green,blue,alpha);
        
        // Fill the circle with the fill color
        CGContextFillEllipseInRect(contextRef, rect);
        
        // Draw the circle border
        CGContextStrokeEllipseInRect(contextRef, rect);
    }
   else {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
    CGContextFillRect(ctx, rect);

    rect = CGRectInset(rect, .5, .5);
    
    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextFillPath(ctx);
    }
}

- (void)setColor:(UIColor *)color
{
    self->_color = color;
    
    [self setNeedsDisplay];
}

@end
