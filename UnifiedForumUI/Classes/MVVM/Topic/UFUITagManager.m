//
//  INSTag.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/3.
//

#import "UFUITagManager.h"

@implementation UFUITagManager

+ (NSArray *)tagsGroupNameArray {
    return @[
        @"开发语言 Objective-C",
        @"Cocoa Touch Foundation",
        @"Cocoa Touch UIKit",
        @"Cocoa Touch App Services",
        @"架构",
        @"性能与安全",
        @"调试，测试与持续集成，开发工具",
        @"计算机软件基础",
        @"其他"
    ];
}

+ (NSArray *)tagsNameArray {
    return @[
        @[
            @"内存管理",
            @"Runtime",
            @"Blocks",
            @"并发编程",
            @"Runloop",
        ],
        
        @[
            @"Fundamentals",
            @"Files and Data Persistence",
            @"Networking",
        ],
        
        @[
            @"App Structure",
            @"App User Interface",
            @"App User Interactions",
        ],
        
        @[
            @"Core Animation",
            @"WebKit",
        ],

        @[
            @"第三方框架",
            @"UML和设计模式",
            @"架构",
        ],
        
        @[
            @"性能优化",
            @"安全",
        ],

        @[
            @"调试",
            @"测试与持续集成",
            @"开发工具",
        ],
        
        @[
            @"数据结构与算法",
            @"编程思想",
            @"计算机网络",
            @"数据库",
        ],
        
        @[
            @"读书笔记",
        ],
    ];
}

@end
