//
//  UFUISplitLineView.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/29.
//

#import "UFUISplitLineView.h"

@implementation UFUISplitLineView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self buildUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    self.backgroundColor = [UIColor separatorColor];
}

@end
