//
//  main.m
//  SortingForArray
//
//  Created by ChenMan on 2017/12/20.
//  Copyright © 2017年 ChenMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <objc/runtime.h>


void handlePrintingOfProperties(void){
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([NSString class], &count);
    // 生成一个属性名称组成的数组
    NSMutableArray *propertyNameArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [propertyNameArray addObject:name];
    }
    NSLog(@"排序前的属性列表 = %@",propertyNameArray);
    
    NSComparator cmptr = ^(NSString *obj1, NSString *obj2){
        return [obj1 compare:obj2 options:NSLiteralSearch];
    };
    NSArray *afterSort = [propertyNameArray sortedArrayUsingComparator:cmptr];
    NSLog(@"排序后的属性列表 = %@",afterSort);
    
    //C语言中,用完copy,create的东西之后,最好释放
    free(properties);
}

void handlePrintingOfIvars(void){
    unsigned int count;// 记录属性个数
    Ivar *properties = class_copyIvarList([NSURL class], &count);
    // 生成一个属性名称组成的数组
    NSMutableArray *propertyNameArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        Ivar property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = ivar_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [propertyNameArray addObject:name];
    }
    NSLog(@"排序前的成员变量列表 = %@",propertyNameArray);
    
    NSComparator cmptr = ^(NSString *obj1, NSString *obj2){
        return [obj1 compare:obj2 options:NSLiteralSearch];
    };
    NSArray *afterSort = [propertyNameArray sortedArrayUsingComparator:cmptr];
    NSLog(@"排序后的成员变量列表 = %@",afterSort);
    
    //C语言中,用完copy,create的东西之后,最好释放
    free(properties);
}

void handleSortingForStrArray(void){
//    NSArray *stringsArray = [NSArray arrayWithObjects:
//                             @"string 10",
//                             @"string 1",
//                             @"string AAA1",
//                             @"string aaa1",
//                             @"string AAA2",
//                             @"string 120",
//                             @"string 1100",
//                             @"string 02000",
//                             nil];
    NSArray *stringsArray = [NSArray arrayWithObjects:
                             @"string b",
                             @"string A",
                             @"string a",
                             @"string \uFF41",
                             @"string a",
                             @"string A",
                             @"string c",
                             @"string d0030",
                             @"string d2",
                             @"アいろはｱｲｳｴイウエ",
                             @"ｱいろはｱｲｳｴｲｳｴ",
                             @"アいろはｱｲｳｴイウエ",nil];
    
    NSStringCompareOptions comparisonOptions = NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    
    NSComparator finderSortBlock = ^(id string1,id string2) {
        
        NSRange string1Range =NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    };
    
    NSArray *finderSortArray = [stringsArray sortedArrayUsingComparator:finderSortBlock];
    NSLog(@"finderSortArray: %@", finderSortArray);
    
}

//void handleSortingForIntArray(void){
//    NSArray *originalArray = @[@(00),@0,@00,@01,@10,@21,@12,@11,@22];
//    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
//    NSComparator finderSort = ^(id string1,id string2){
//        if ([string1 integerValue] > [string2 integerValue]) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }else if ([string1 integerValue] < [string2 integerValue]){
//            return (NSComparisonResult)NSOrderedAscending;
//        }else{
//            return (NSComparisonResult)NSOrderedSame;
//        }
//    };
//    //数组排序：
//    NSArray *resultArray = [originalArray sortedArrayUsingComparator:finderSort];
//    NSLog(@"Int数组排序结果：%@",resultArray);
//}

void handleSortingForIntStrArray(void){
    NSArray *originalArray = @[@"00",@"0",@"00",@"01",@"10",@"21",@"12",@"11",@"22"];
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    NSComparator finderSort = ^(id string1,id string2){
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    };
    //数组排序：
    NSArray *resultArray = [originalArray sortedArrayUsingComparator:finderSort];
    NSLog(@"第一种排序结果：%@",resultArray);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        NSLog(@"Results of handleSortingForStrArray()**********************");
//        handleSortingForStrArray();
//        NSLog(@"Results of handleSortingForIntArray()**********************");
//        handleSortingForIntStrArray();
//        NSLog(@"handlePrintingOfProperties()**********************");
//        handlePrintingOfProperties();
        NSLog(@"handlePrintingOfIvars()**********************");
        handlePrintingOfIvars();
    }
    return 0;
}

