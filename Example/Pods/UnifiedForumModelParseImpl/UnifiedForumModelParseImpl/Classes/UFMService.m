//
//  UFMService.m
//  GlobalDataModel
//
//  Created by XueFeng Chen on 2022/11/1.
//

#import "UFMService.h"

static NSDictionary *currentConfiguration_;

@implementation UFMService

+ (void)initializeWithConfiguration:(NSDictionary *)configuration {
    currentConfiguration_ = [configuration copy];
    
    NSString *applicationId = currentConfiguration_[@"applicationId"];
    NSString *clientKey = currentConfiguration_[@"clientKey"];
    NSString *server = currentConfiguration_[@"server"];

    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = applicationId;
        configuration.clientKey = clientKey;
        configuration.server = server;
        configuration.networkRetryAttempts = 0;
    }]];
}

@end
