//
//  UITableView+NXEmptyView.m
//  TableWithEmptyView
//
//  Created by Ullrich Schäfer on 21.06.12.
//
//

#import <objc/runtime.h>

#import "UITableView+NXEmptyView.h"


static const NSString *NXEmptyViewAssociatedKey = @"NXEmptyViewAssociatedKey";
static const NSString *NXEmptyViewHideSeparatorLinesAssociatedKey = @"NXEmptyViewHideSeparatorLinesAssociatedKey";
static const NSString *NXEmptyViewPreviousSeparatorStyleAssociatedKey = @"NXEmptyViewPreviousSeparatorStyleAssociatedKey";


void nxEV_swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}



@interface UITableView (NXEmptyViewPrivate)
@property (nonatomic, assign) UITableViewCellSeparatorStyle nxEV_previousSeparatorStyle;
@end


@implementation UITableView (NXEmptyView)

#pragma mark Entry

+ (void)load;
{
    Class c = [UITableView class];
    nxEV_swizzle(c, @selector(reloadData), @selector(nxEV_reloadData));
    nxEV_swizzle(c, @selector(layoutSubviews), @selector(nxEV_layoutSubviews));
}

#pragma mark Properties

- (BOOL)nxEV_hasRowsToDisplay;
{
    NSUInteger numberOfRows = 0;
    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++) {
        numberOfRows += [self numberOfRowsInSection:sectionIndex];
    }
    return (numberOfRows > 0);
}

@dynamic nxEV_emptyView;
- (UIView *)nxEV_emptyView;
{
    return objc_getAssociatedObject(self, &NXEmptyViewAssociatedKey);
}

- (void)setNxEV_emptyView:(UIView *)value;
{
    if (self.nxEV_emptyView.superview) {
        [self.nxEV_emptyView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &NXEmptyViewAssociatedKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self nxEV_updateEmptyView];
}

@dynamic nxEV_hideSeparatorLinesWhenShowingEmptyView;
- (BOOL)nxEV_hideSeparatorLinesWhenShowingEmptyView
{
    NSNumber *hideSeparator = objc_getAssociatedObject(self, &NXEmptyViewHideSeparatorLinesAssociatedKey);
    return hideSeparator ? [hideSeparator boolValue] : NO;
}

- (void)setNxEV_hideSeparatorLinesWhenShowingEmptyView:(BOOL)value
{
    NSNumber *hideSeparator = [NSNumber numberWithBool:value];
    objc_setAssociatedObject(self, &NXEmptyViewHideSeparatorLinesAssociatedKey, hideSeparator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark Updating

- (void)nxEV_updateEmptyView;
{
    UIView *emptyView = self.nxEV_emptyView;
    
    if (!emptyView) return;
    
    if (emptyView.superview != self) {
        [self addSubview:emptyView];
    }
    
    // setup empty view frame
    CGRect frame = self.bounds;
    frame.origin = CGPointMake(0, 0);
    frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(CGRectGetHeight(self.tableHeaderView.frame), 0, 0, 0));
    frame.size.height -= self.contentInset.top;
    emptyView.frame = frame;
    emptyView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    // check available data
    BOOL emptyViewShouldBeShown = (self.nxEV_hasRowsToDisplay == NO);
    
    // check bypassing
    if (emptyViewShouldBeShown && [self.dataSource respondsToSelector:@selector(tableViewShouldBypassNXEmptyView:)]) {
        BOOL emptyViewShouldBeBypassed = [(id<UITableViewNXEmptyViewDataSource>)self.dataSource tableViewShouldBypassNXEmptyView:self];
        emptyViewShouldBeShown &= !emptyViewShouldBeBypassed;
    }
    
    // hide tableView separators, if present
    if (self.nxEV_hideSeparatorLinesWhenShowingEmptyView) {
        if (emptyViewShouldBeShown) {
            if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
                self.nxEV_previousSeparatorStyle = self.separatorStyle;
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        } else {
            if (self.separatorStyle != self.nxEV_previousSeparatorStyle) {
                // we've seen an issue with the separator color not being correct when setting separator style during layoutSubviews
                // that's why we schedule the call on the next runloop cycle
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.separatorStyle = self.nxEV_previousSeparatorStyle;
                });
                
            }
        }
    }
    
    // show / hide empty view
    emptyView.hidden = !emptyViewShouldBeShown;
}


#pragma mark Swizzle methods

- (void)nxEV_reloadData;
{
    // this calls the original reloadData implementation
    [self nxEV_reloadData];
    
    [self nxEV_updateEmptyView];
}

- (void)nxEV_layoutSubviews;
{
    // this calls the original layoutSubviews implementation
    [self nxEV_layoutSubviews];
    
    [self nxEV_updateEmptyView];
}

@end


#pragma mark Private
#pragma mark -

@implementation UITableView (NXEmptyViewPrivate)

@dynamic nxEV_previousSeparatorStyle;
- (UITableViewCellSeparatorStyle)nxEV_previousSeparatorStyle
{
    NSNumber *previousSeparatorStyle = objc_getAssociatedObject(self, &NXEmptyViewPreviousSeparatorStyleAssociatedKey);
    return previousSeparatorStyle ? [previousSeparatorStyle intValue] : self.separatorStyle;
}

- (void)setNxEV_previousSeparatorStyle:(UITableViewCellSeparatorStyle)value
{
    NSNumber *previousSeparatorStyle = [NSNumber numberWithInt:value];
    objc_setAssociatedObject(self, &NXEmptyViewPreviousSeparatorStyleAssociatedKey, previousSeparatorStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
