//
//  JReaderManager.m
//  JReaderDemo
//
//  Created by Jerry on 2017/9/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "JReaderManager.h"
#import <objc/runtime.h>
#import "JReaderAnimationViewController.h"

@interface JReaderManager () <JReaderAnimationViewControllerDataSource, JReaderAnimationViewControllerDelegate>

@property (nonatomic, strong) JReaderAnimationViewController *jReaderAnimationViewController;
@property (nonatomic, strong) UIView *jReaderBrightnessView;

@end

@implementation JReaderManager

@synthesize userDefinedProperty = _userDefinedProperty;

- (instancetype)initWithJReaderModel:(JReaderModel *)jReaderModel pageIndex:(NSInteger)pageIndex {
    self = [super init];
    if (self) {
        self.jReaderModel = jReaderModel;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userInteractionEnabled = YES;
    [self addChildViewController:self.jReaderAnimationViewController];
    [self.view addSubview:self.jReaderAnimationViewController.view];
    self.jReaderAnimationViewController.view.frame = CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT);
    [self.view addSubview:self.jReaderBrightnessView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 内部方法
#pragma mark 获取Model所有属性
- (NSArray *)allModelPropertyNames {
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self.jReaderModel class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        [propertyNamesArr addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertys);
    return propertyNamesArr;
}

#pragma mark 从新加载数据
- (void)jReaderManagerReload {
    self.jReaderBrightnessView.alpha = 0.8 - (1 - self.jReaderModel.jReaderBrightness) * 0.8;
    self.jReaderAnimationViewController.jReaderModel = self.jReaderModel;
}
#pragma mark 获取分页后的索引
- (NSInteger)jReaderPageIndexWith:(NSString *)pageStr {
    return [self.jReaderAnimationViewController jReaderPageIndexWith:pageStr];
}

#pragma mark - JReaderAnimationViewControllerDataSource
#pragma mark 翻页开始
- (void)jReaderAnimationViewController:(nullable JReaderAnimationViewController *)jReaderAnimationViewController {
    if ([self.delegate respondsToSelector:@selector(jReaderManager:)]) {
        [self.delegate jReaderManager:self];
    }
}
#pragma mark 翻页结束
- (void)jReaderAnimationViewController:(nullable JReaderAnimationViewController *)jReaderAnimationViewController didFinishAnimating:(BOOL)finished transitionCompleted:(BOOL)completed {
    if ([self.delegate respondsToSelector:@selector(jReaderManager:didFinishAnimating:transitionCompleted:)]) {
        [self.delegate jReaderManager:self didFinishAnimating:finished transitionCompleted:completed];
    }
}

#pragma mark - JReaderAnimationViewControllerDelegate
#pragma mark 获取指定章节内容
- (NSString *)appointContent:(JReaderAnimationViewController *)jReaderAnimationViewController userDefinedProperty:(id)userDefinedProperty {
    if ([self.dataSource respondsToSelector:@selector(jReaderManager:userDefinedPropertyAppoint:)]) {
        return [self.dataSource jReaderManager:self userDefinedPropertyAppoint:userDefinedProperty];
    }
    return nil;
}
#pragma mark 获取上一章内容 
- (nullable NSString *)beforeContent:(nullable JReaderAnimationViewController *)jReaderAnimationViewController userDefinedProperty:(nullable id)userDefinedProperty {
    if ([self.dataSource respondsToSelector:@selector(jReaderManager:userDefinedPropertyBefore:)]) {
        return [self.dataSource jReaderManager:self userDefinedPropertyBefore:userDefinedProperty];
    }
    return nil;
}
#pragma mark 获取下一章内容
- (nullable NSString *)afterContent:(nullable JReaderAnimationViewController *)jReaderAnimationViewController userDefinedProperty:(nullable id)userDefinedProperty {
    if ([self.dataSource respondsToSelector:@selector(jReaderManager:userDefinedPropertyAfter:)]) {
        return [self.dataSource jReaderManager:self userDefinedPropertyAfter:userDefinedProperty];
    }
    return nil;
}
#pragma mark 点击手势回调
- (BOOL)jReaderAnimationViewController:(JReaderAnimationViewController *)jReaderAnimationViewController tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(jReaderManager:tapGestureRecognizer:)]) {
        return [self.delegate jReaderManager:self tapGestureRecognizer:tapGestureRecognizer];
    }
    return YES;
}

#pragma mark get/set
- (void)setJReaderModel:(JReaderModel *)jReaderModel {
    _jReaderModel = jReaderModel;
}
- (JReaderAnimationViewController *)jReaderAnimationViewController {
    if (!_jReaderAnimationViewController) {
        _jReaderAnimationViewController = [[JReaderAnimationViewController alloc] init];
        _jReaderAnimationViewController.delegate = self;
        _jReaderAnimationViewController.dataSource = self;
    }
    return _jReaderAnimationViewController;
}
- (NSString *)jReaderPageString {
    return self.jReaderAnimationViewController.jReaderPageString;
}
- (UIView *)jReaderBrightnessView {
    if (!_jReaderBrightnessView) {
        _jReaderBrightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JREADER_SCREEN_WIDTH, JREADER_SCREEN_HEIGHT)];
        _jReaderBrightnessView.backgroundColor = [UIColor blackColor];
        _jReaderBrightnessView.alpha = 0.8 - (1 - self.jReaderModel.jReaderBrightness) * 0.8;
        _jReaderBrightnessView.userInteractionEnabled = NO;
    }
    return _jReaderBrightnessView;
}
- (void)setUserDefinedProperty:(id)userDefinedProperty {
    _userDefinedProperty = userDefinedProperty;
    self.jReaderAnimationViewController.userDefinedProperty = userDefinedProperty;
}
- (id)userDefinedProperty {
    return self.jReaderAnimationViewController.userDefinedProperty;
}
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    self.jReaderAnimationViewController.userInteractionEnabled = userInteractionEnabled;
}

@end
