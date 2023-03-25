//
//  UFUIObjectCellViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/15.
//

#import "UFUIObjectCellViewModel.h"

#import "UFUIObjectCell.h"

@implementation UFUIObjectCellViewModel

// 默认的，必须由子类重载
- (instancetype)initWithObjectModel:(UFMObjectModel *)objectModel {
    if (self = [super init]) {
        _cellIdentifier = NSStringFromClass([UFUIObjectCell class]);
        _objectModel = objectModel;
    }
    
    return self;
}

@end
