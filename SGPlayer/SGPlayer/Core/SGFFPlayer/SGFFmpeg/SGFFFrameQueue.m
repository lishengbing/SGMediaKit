//
//  SGFFFrameQueue.m
//  SGMediaKit
//
//  Created by Single on 18/01/2017.
//  Copyright © 2017 single. All rights reserved.
//

#import "SGFFFrameQueue.h"

@interface SGFFFrameQueue ()

@property (nonatomic, assign) int count;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) NSCondition * condition;
@property (nonatomic, strong) NSMutableArray <SGFFFrame *> * frames;

@property (nonatomic, assign) BOOL destoryToken;

@end

@implementation SGFFFrameQueue

+ (instancetype)frameQueue
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frames = [NSMutableArray array];
        self.condition = [[NSCondition alloc] init];
    }
    return self;
}

- (void)putFrame:(SGFFFrame *)frame
{
    if (!frame) return;
    [self.condition lock];
    [self.frames addObject:frame];
    self.duration += frame.duration;
    [self.condition signal];
    [self.condition unlock];
}

- (SGFFFrame *)getFrame
{
    [self.condition lock];
    while (!self.frames.firstObject) {
        if (self.destoryToken) {
            [self.condition unlock];
            return nil;
        }
        [self.condition wait];
    }
    SGFFFrame * frame = self.frames.firstObject;
    [self.frames removeObjectAtIndex:0];
    self.duration -= frame.duration;
    [self.condition unlock];
    return frame;
}

- (void)flush
{
    [self.condition lock];
    [self.frames removeAllObjects];
    self.duration = 0;
    [self.condition unlock];
}

- (void)destroy
{
    [self flush];
    [self.condition lock];
    self.destoryToken = YES;
    [self.condition broadcast];
    [self.condition unlock];
}

- (int)count
{
    return self.frames.count;
}

+ (int)maxVideoDuration
{
    return 1;
}

+ (NSTimeInterval)sleepTimeInterval
{
    return [self maxVideoDuration] / 2.0f;
}

@end