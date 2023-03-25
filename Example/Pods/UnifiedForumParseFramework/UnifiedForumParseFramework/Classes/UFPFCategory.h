//
//  UFPFCategory.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/4/19.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFPFCategory : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) PFFileObject *iconImageFileObject;
@property (nonatomic, strong) PFFileObject *backgroundImageFileObject;

@end

NS_ASSUME_NONNULL_END
