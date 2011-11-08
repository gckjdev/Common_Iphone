//
//  PPSegmentControl.m
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPSegmentControl.h"


#define BACKGROUND_SCALE 0.7
@implementation PPSegmentControl

@synthesize numberOfSegments;
@synthesize selectedSegmentIndex;
@synthesize selectedSegmentImageView = _selectedSegmentImageView;
@synthesize backgroudImageView = _backgroudImageView;
@synthesize delegate;

- (void) dealloc
{
    [_segments release];
    [_backgroudImageView release];
    [_selectedSegmentImageView release];
    [_textFont release];;
    [_selectedSegmentTextFont release];;
    [_textColor release];;
    [_selectedSegmentTextColor release];
    [super dealloc];
    
}
- (BOOL)isIndexValid:(NSInteger)index
{
    if (index >=0 && index < [_segments count]) {
        return YES;
    }
    return NO;
}

- (UIButton *)selectedButton
{
    if ([self isIndexValid:selectedSegmentIndex]) {
        return [_segments objectAtIndex:selectedSegmentIndex];
    }
    return nil;
}

-(void) defaultSetting
{
    _segments = [[NSMutableArray alloc]init];
    self.backgroudImageView = [[UIImageView alloc] init];
    self.selectedSegmentImageView = [[UIImageView alloc] init];
    _textColor = [UIColor yellowColor];
    _selectedSegmentTextColor = [UIColor redColor];
    _textFont = [UIFont systemFontOfSize:14];
    _selectedSegmentTextFont = [UIFont systemFontOfSize:14];
    segmentWidth = 0;
    segmentHeight = 0;
    [self addSubview:self.backgroudImageView];
    [self addSubview:self.selectedSegmentImageView];
}

- (void) setSegment:(UIButton *)button Color:(UIColor *)color font:(UIFont *)font
{
    if (button) {
        [button setTitleColor:color forState:UIControlStateNormal];
        [button.titleLabel setFont:font];
    }
    
}


- (void)clickSeg:(id)sender
{
    UIButton *seg = sender;
    if (seg) {
        NSInteger index = [_segments indexOfObject:seg];
        [self setSelectedSegmentIndex:index];
    }
}

-(id) initWithItems:(NSArray *)titleArray defaultSelectIndex:(int)defaultSelectIndex 
              frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetting];
        if (titleArray && [titleArray count] > 0) {
            numberOfSegments =[titleArray count];
            segmentHeight = frame.size.height;
            segmentWidth = frame.size.width / numberOfSegments;
            NSInteger i = 0;
            
            //set backgroud image;
            CGFloat backgroundHeight = segmentHeight * BACKGROUND_SCALE;
            CGFloat backgroundWidth = frame.size.width;
            CGFloat y = (segmentHeight - backgroundHeight) / 2.0;
            [self.backgroudImageView setFrame:CGRectMake(0, y, backgroundWidth, backgroundHeight)];
            
            
            //set button type, text and image;
            for (NSString *title in titleArray) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake((i++) * segmentWidth , 0, segmentWidth, segmentHeight)];
                [button setTitle:title forState:UIControlStateNormal];
                [self setSegment:button Color:_textColor font:_textFont];
                [self addSubview:button];
                [button addTarget:self action:@selector(clickSeg:) forControlEvents:UIControlEventTouchUpInside];
                [_segments addObject:button];
            }
            
            if ([self isIndexValid:defaultSelectIndex]) {
                selectedSegmentIndex = defaultSelectIndex;
            }else{
                selectedSegmentIndex = UISegmentedControlNoSegment;
            }
            // set selected button text font and color;
            UIButton *button = [self selectedButton];
            if (button) {
                [self.selectedSegmentImageView setFrame:button.frame];
                [self setSegment:button Color:_selectedSegmentTextColor font:_selectedSegmentTextFont];
            }
        }
    }
    return self;
}

- (void) setSelectedSegmentTextColor:(UIColor *)color
{
    _selectedSegmentTextColor = color;
    UIButton *seg = [self selectedButton];
    if (seg) {
        [self setSegment:seg Color:color font:_selectedSegmentTextFont];   
    }
}

- (void) setSelectedSegmentTextFont:(UIFont *)font
{
    _selectedSegmentTextFont = font;
    UIButton *seg = [self selectedButton];
    if (seg) {
        [self setSegment:seg Color:_selectedSegmentTextColor font:font];
    }
    
}

- (void) setTextColor:(UIColor *)color
{
    _textColor = color;
    for (int i = 0; i < [_segments count];  ++ i) {
        if (i != selectedSegmentIndex) {
            UIButton *seg = [_segments objectAtIndex:i];
            [self setSegment:seg Color:_textColor font:_textFont];
        }
    }
}
- (void) setTextFont: (UIFont *)font
{
    _textFont = font;
    for (int i = 0; i < [_segments count];  ++ i) {
        if (i != selectedSegmentIndex) {
            UIButton *seg = [_segments objectAtIndex:i];
            [self setSegment:seg Color:_textColor font:_textFont];
        }
    }
}

- (void) setSegmentFrame:(CGRect)frame
{
    self.frame = frame;
    
    //set backgroud view frame
    segmentHeight = frame.size.height;
    segmentWidth = frame.size.width / numberOfSegments;
    
    CGFloat backgroundHeight = segmentHeight * BACKGROUND_SCALE;
    CGFloat backgroundWidth = frame.size.width;
    CGFloat y = (segmentHeight - backgroundHeight) / 2.0;
    [self.backgroudImageView setFrame:CGRectMake(0, y, backgroundWidth, backgroundHeight)];
    
    //set button frame
    int i = 0;
    for (UIButton *seg in _segments) {
        [seg setFrame:CGRectMake( (i++) * segmentWidth, 0, segmentWidth, segmentHeight)];
    }
    //set selected image view frame
    [self.selectedSegmentImageView setFrame:[[self selectedButton] frame]];
}

//set and get segment title;
- (NSString*) titleForSegmentAtIndex:(NSInteger )index
{
    if ([self isIndexValid:index]) {
        UIButton *seg = [_segments objectAtIndex:index]; 
        return seg.titleLabel.text;
    }
    return nil;
}

- (void) setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    if ([self isIndexValid:segment]) {
        UIButton *seg = [_segments objectAtIndex:segment]; 
        seg.titleLabel.text = title;
    }
}

- (NSString *) titleForSelectedSegment
{
    UIButton *seg = [self selectedButton];
    if (seg) {
        return seg.titleLabel.text;
    }
    return nil;
}

- (void) setSelectedSegmentIndex:(NSInteger)index
{
    //invalid segment index
    if (![self isIndexValid:index]) {
        [self.selectedSegmentImageView setHidden:YES];
        selectedSegmentIndex = UISegmentedControlNoSegment;
    }else{
        if (index == selectedSegmentIndex) {
            return;
        }
        
        UIButton *oldButton = [self selectedButton];
        
        selectedSegmentIndex = index;
        UIButton *seg = [self selectedButton];
        
        [self setSegment:seg Color:_selectedSegmentTextColor font:_selectedSegmentTextFont];
        [self setSegment:oldButton Color:_textColor font:_textFont];
        
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:0.5];
        [UIImageView setAnimationBeginsFromCurrentState:YES];
        [self.selectedSegmentImageView setFrame:seg.frame];
        [UIImageView commitAnimations];
        [self.selectedSegmentImageView setHidden:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSegmentValueChange:)]) {
            [self.delegate didSegmentValueChange:self];
        }
    }
}

- (void) setBackgroundImage:(UIImage *)backgroundImage
{
    [self.backgroudImageView setImage:backgroundImage];
}

- (void) setSelectedSegmentImage:(UIImage *)selectedSegmentImage
{
    [self.selectedSegmentImageView setImage:selectedSegmentImage];
}

- (void) setContentOffset:(CGFloat)x y:(CGFloat)y
{
    
    [self.backgroudImageView setFrame:CGRectMake(_backgroudImageView.frame.origin.x + x, _backgroudImageView.frame.origin.y + y, _backgroudImageView.frame.size.width, _backgroudImageView.frame.size.height)];
    
    [self.selectedSegmentImageView setFrame:CGRectMake(_selectedSegmentImageView.frame.origin.x + x, _selectedSegmentImageView.frame.origin.y + y, _selectedSegmentImageView.frame.size.width, _selectedSegmentImageView.frame.size.height)];
    for (UIButton *seg in _segments) {
        [seg setFrame:CGRectMake(seg.frame.origin.x + x, seg.frame.origin.y + y, seg.frame.size.width, seg.frame.size.height)];
    }
}

@end
