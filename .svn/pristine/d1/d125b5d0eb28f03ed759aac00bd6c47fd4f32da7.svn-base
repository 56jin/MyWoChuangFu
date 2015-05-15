//
//  passParams.m
//  WoChuangFu
//
//  Created by duwl on 12/22/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "passParams.h"

@implementation passParams
@synthesize params;

static passParams* _passParams = nil;

- (void)dealloc
{
    if(params != nil){
        [params release];
    }
    [super dealloc];
}

+(passParams*)sharePassParams
{
    @synchronized ([passParams class]) {
        if (_passParams == nil) {
			_passParams = [[passParams alloc] passInit];
            return _passParams;
        }
    }
    return _passParams;
}

-(id)passInit
{
    self = [super init];
    NSMutableDictionary* pass = [[NSMutableDictionary alloc] init];
    self.params = pass;
    [pass release];
    
    return self;
}

@end
