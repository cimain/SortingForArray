
# iOS开发·必会的算法操作：字符串数组排序+模型对象数组排序



# 前面的话
为了给字符串数组排序，除了用C/C++的基本办法，iOS开发者更应该学会利用苹果专门为**NSArray** 排序提供的**sortedArrayUsingComparator** 方法：

```
- (NSArray<ObjectType> *)sortedArrayUsingComparator:(NSComparator NS_NOESCAPE)cmptr NS_AVAILABLE(10_6, 4_0);
```

其中，需要设置一个**NSComparator** 参数，它是一个block，查看定义如下：
```
typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);
```
这个block体返回的**NSComparisonResult** 是一个枚举类型，它的定义是：
```
typedef NS_ENUM(NSInteger, NSComparisonResult) {NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending};
```
> 问题来了，怎么设置？

- 为了设置这个**NSComparator** 参数的block体，你可以在设置其block体的时候，手动返回一个**NSComparisonResult** 枚举类型的某个具体值（**NSOrderedAscending**, **NSOrderedSame**, **NSOrderedDescending** 三选一）：

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5b837c998e?w=1240&h=418&f=png&s=178143)

- 如果数组里面是字符串，在设置其block体的时候，你也可以利用苹果专门为**NSString** 提供的字符串比较方法，获得一个**NSComparisonResult** 类型，将其自动返回。

```
- (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToCompare locale:(nullable id)locale; // locale arg used to be a dictionary pre-Leopard. We now accept NSLocale. Assumes the current locale if non-nil and non-NSLocale. nil continues to mean canonical compare, which doesn't depend on user's locale choice.
```


![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5b8339e10b?w=1240&h=205&f=png&s=125496)



这时候，就需要了解**NSStringCompareOptions** 的意思。但如果你搜索一下**NSStringCompareOptions** ，会发现很多文章中的翻译或者中文解释在误导，或者很难看清什么意思？例如下面这篇博客：

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5b84f50b00?w=1240&h=742&f=png&s=354395)

然后，相同的解释文案还以讹传讹的传开来了，例如你看下面这个博客：

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5d587e2c6f?w=1240&h=799&f=png&s=247510)

于是，笔者决定写此本文，好好展示他们的用途。


# 1. 第一种：数组的字符串元素里面是基本数据类型
---
### 1.1 字符串数组排序示例
##### 1.1.1 实验代码
- main.m
```
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
        NSLog(@"Results of handleSortingForIntArray()**********************");
        handleSortingForIntStrArray();
    }
    return 0;
}
```
##### 1.1.2 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5b855576da?w=1170&h=408&f=png&s=49625)


##### 1.1.3 实验结论

- 依据数组元素的数值大小返回升序数组

### 1.2 NSComparator与NSComparisonResult
上面的代码中用到了NSComparator与NSComparisonResult，在本文的“前面的话”中已经介绍过，这里重新列一下定义。
##### 1.2.1 NSComparator
```
typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);
```
##### 1.2.2 NSComparisonResult
```
typedef NS_ENUM(NSInteger, NSComparisonResult) {NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending};
```

# 2. 第二种：数组的字符串元素里面不是基本数据类型
---
### 2.1 示例：字符串数组排序
##### 2.1.1 实验代码
- main.m
```
//
//  main.m
//  SortingForArray
//
//  Created by ChenMan on 2017/12/20.
//  Copyright © 2017年 ChenMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>

void handleSortingForStrArray(void){
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
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSComparator finderSortBlock = ^(id string1,id string2) {
        
        NSRange string1Range =NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:nil range:string1Range locale:currentLocale];
    };
    
    NSArray *finderSortArray = [stringsArray sortedArrayUsingComparator:finderSortBlock];
    NSLog(@"finderSortArray: %@", finderSortArray);
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Results of handleSortingForStrArray()**********************");
        handleSortingForStrArray();
    }
    return 0;
}
```
##### 2.1.2 运行结果：

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5d5a4e7375?w=1200&h=484&f=png&s=94341)


##### 2.1.3 实验结论：

如上实验代码中，有这样一行代码：
```
return [string1 compare:string2 options:nil range:string1Range locale:currentLocale];
```
根据运行结果，可知如下结论：

- 即使在`- (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToCompare locale:(nullable id)locale; `中将`(NSStringCompareOptions)`枚举类型的参数设置为`nil`，也可以运行。但一般不这么做，这里只是为了观察不指定该枚举参数时候系统的默认设置，并与本文接下来指定该枚举参数的排序结果对比。
- 可以发现：
  - 默认同一字符的全角字符看做半角字符。不区分同一个字符（如日文的片假字）的半角与全角状态。相同元素，维持原序。
  - 默认区分字母大小写，同一个字符小写在前，大写在后。
  - 字母并非按unicode码的大小升序排列。例如，`全角a`的unicode为FF41，`半角a`的unicode为0061，`半角A`的unicode为0041，`半角b`的unicode为0062，但排序结果是 `全角a` = `半角a` < `半角A` < `半角b`。
  - 默认不识别含有数字字符的数值大小，0030虽然数学意义比2大，但是，仅从字符串的角度看，第一个字符0比2小，所以d0030排在d2前面。

##### 2.1.4 知识拓展：
> 半角与全角字符
  - 全角占两个字节，半角占一个字节。通常我们碰到的英文字母、数字键、符号键这种ASCII码系统里面的字符大多数情况下是半角的。

  - 国内汉字输入法输入的汉字为全角，字母数字为半角，但是标点则默认为全角，可切换为半角（可以通过输入法工具条上的相应按钮来切换标点符号的全角半角状态）。
 
  - 日文里面的有汉字，也有片假字。这个片假字有两套编码，同一个片假字分别有半角和全角两种编码。例如：看起来像一样的片假字组成的句子，全角状态`ア`字符开头的为`アいろはｱｲｳｴイウエ`，半角状态`ｱ`字符开头的为`ｱいろはｱｲｳｴｲｳｴ`。可以看到，明显同一个片假字的**全角状态** 比**半角状态** “胖”一圈。

-  英文字母其实也有全角字母，例如小写的`a`，其半角形式的unicode码为0061，其全角形式的unicode码为FF41。可查阅[Unicode®字符百科](https://unicode-table.com/cn/)官网。


### 2.2 NSStringCompareOptions

NSStringCompareOptions是一个枚举类型，并非一个类。打开NSStringCompareOptions的定义，可查看如下
```
typedef NS_OPTIONS(NSUInteger, NSStringCompareOptions) {
    NSCaseInsensitiveSearch = 1,
    NSLiteralSearch = 2,		/* Exact character-by-character equivalence */
    NSBackwardsSearch = 4,		/* Search from end of source string */
    NSAnchoredSearch = 8,		/* Search is limited to start (or end, if NSBackwardsSearch) of source string */
    NSNumericSearch = 64,		/* Added in 10.2; Numbers within strings are compared using numeric value, that is, Foo2.txt < Foo7.txt < Foo25.txt; only applies to compare methods, not find */
    NSDiacriticInsensitiveSearch API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)) = 128, /* If specified, ignores diacritics (o-umlaut == o) */
    NSWidthInsensitiveSearch API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)) = 256, /* If specified, ignores width differences ('a' == UFF41) */
    NSForcedOrderingSearch API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)) = 512, /* If specified, comparisons are forced to return either NSOrderedAscending or NSOrderedDescending if the strings are equivalent but not strictly equal, for stability when sorting (e.g. "aaa" > "AAA" with NSCaseInsensitiveSearch specified) */
    NSRegularExpressionSearch API_AVAILABLE(macos(10.7), ios(3.2), watchos(2.0), tvos(9.0)) = 1024    /* Applies to rangeOfString:..., stringByReplacingOccurrencesOfString:..., and replaceOccurrencesOfString:... methods only; the search string is treated as an ICU-compatible regular expression; if set, no other options can apply except NSCaseInsensitiveSearch and NSAnchoredSearch */
};
```

##### 2.2.1 NSNumericSearch

> 官方解释：Added in 10.2; Numbers within strings are compared using numeric value, that is, Foo2.txt < Foo7.txt < Foo25.txt; only applies to compare methods, not find

- 假设，将上例中的部分代码修改为
```
void handleSortingForStrArray(void){
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
    NSStringCompareOptions comparisonOptions = NSNumericSearch;
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSComparator finderSortBlock = ^(id string1,id string2) {
        
        NSRange string1Range =NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    };
    
    NSArray *finderSortArray = [stringsArray sortedArrayUsingComparator:finderSortBlock];
    NSLog(@"finderSortArray: %@", finderSortArray);
}
```
- 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5b8be0c123?w=1156&h=530&f=png&s=98132)


- 结论
`NSStringCompareOptions`指定为`NSNumericSearch`，当字符串中含有数字时，从数值大小的角度按升序排序。

##### 2.2.2 NSCaseInsensitiveSearch

> 官方解释：无。英文字面解释：不区分字母大小写。

- 假设，将上例中的部分代码修改为
```
NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch; 
```
- 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5b996ca3aa?w=1184&h=488&f=png&s=93423)


- 结论
`NSStringCompareOptions`指定为`NSCaseInsensitiveSearch`，不区分同一个字母的大小写状态，如`a`与`A`看做相同元素，若其它条件也一致则保持原序。

##### 2.2.3 NSLiteralSearch

> 官方解释：Exact character-by-character equivalence

- 假设，将上例中的部分代码修改为
```
NSStringCompareOptions comparisonOptions = NSLiteralSearch;
```

- 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5baebfc221?w=1122&h=522&f=png&s=95444)

- 结论
  -  ***区分*** 同一个字符（如日文的片假字）的半角与全角状态，同一片假字的全角状态小于半角状态。
  -  其它规则，继续按系统默认排序规则排序，包括**默认区分** 字母大小写，以及其它默认排序规则。
  - 按照官方英文说明，这个规则是指区分每个字符的等效状态。只要unicode不同的字符，就不认可他们“等效”，即使他们的语言上的含义相同。


- 题外话
  - 所以，有的文献说**NSLiteralSearch** 是区分大小写是误导，系统本就**默认区分** 字母大小写，这些人以为苹果公司提供这个功能来画蛇添足干嘛？而且可以看看官方英文说明，也不是这个意思。只有指定**不区分** 字母大小写的**NSCaseInsensitiveSearch**，要么不写，即默认**区分**。



##### 2.2.4 NSWidthInsensitiveSearch
> 官方解释：If specified, ignores width differences ('a' == UFF41)
- 假设，将上例中的部分代码修改为
```
NSStringCompareOptions comparisonOptions = NSWidthInsensitiveSearch;
```

- 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5baf52dd62?w=1206&h=470&f=png&s=95331)

- 结论
  -  **不区分** 同一个字符（如日文的片假字）的半角与全角状态，同一片假字的全角状态等于半角状态。
  -  其它规则，继续按系统默认排序规则排序，包括**默认区分** 字母大小写，以及其它默认排序规则。
  -  同时指定两个时，**NSWidthInsensitiveSearch** 比**NSLiteralSearch** 的优先级高，综合起来的结果是**不区分** 半角全角。
  - 官方英文说明中的`UFF41`是指`全角a`，`'a'` 是指`半角a`，如果指定**NSWidthInsensitiveSearch**，则不区分字符的全角半角，即使你同时指定了**NSLiteralSearch**。

即，当有如下代码
```
NSStringCompareOptions comparisonOptions = NSWidthInsensitiveSearch | NSLiteralSearch;
```
其作用相当于没有NSLiteralSearch的代码
```
NSStringCompareOptions comparisonOptions = NSWidthInsensitiveSearch;
```

##### 2.2.5 NSForcedOrderingSearch
> 官方解释：If specified, comparisons are forced to return either NSOrderedAscending or NSOrderedDescending if the strings are equivalent but not strictly equal, for stability when sorting (e.g. "aaa" > "AAA" with NSCaseInsensitiveSearch specified)

- 假设，将上例中的部分代码修改为
```
NSStringCompareOptions comparisonOptions = NSForcedOrderingSearch;
```
- 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5bb3b8663b?w=1208&h=492&f=png&s=96670)

- 结论
  - 不存在字符等不等效相不相等的概念了，只要unicode不一样的字符，必须区分，必须返回一个谁大谁小的结果（NSOrderedAscending or NSOrderedDescending）。
  - 从英文说明也可以看出，**NSForcedOrderingSearch** 的优先级最高，即如果你同时指定了其它有可能作用冲突的枚举类型，也以**NSForcedOrderingSearch** 的作用为准。

##### 2.2.6 综合应用
- 一个比较多的应用示例是，区分字母大小写，区分数值大小，区分半角全角，并强制性指定区分unicode不一样的字符。综合这些条件，写起来就是：
```
NSStringCompareOptions comparisonOptions = NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
```
- 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5bb53864bb?w=1184&h=476&f=png&s=94997)

##### 2.2.7 误导用法
- 我看过有很多其它博客用了这样的误导示例：
```
NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
```
这里面，NSCaseInsensitiveSearch是为了不区分大小写字母，但是后面再加个NSForcedOrderingSearch想强制区分字符又是怎么回事？虽然，这样写并不会报错，运行效果跟上面的综合示例一摸一样。但这样误导的想法是个逻辑矛盾。不信，你看看它运行的结果：

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5bb65dc318?w=1174&h=462&f=png&s=91486)


# 3. 数组里面是类的对象
---
需求：假设我们根据后台返回的JSON字典数组用MJExtension转换成模型数组，现在我们需要根据ID或者Age对模型数组进行排序。

- Pesson.m
```
#import <Foundation/Foundation.h>  
  
@interface Person : NSObject  
@property (nonatomic,copy) NSString *ID;  
@property (nonatomic,copy) NSString *name;  
@property (nonatomic,assign) int age;  
@end  
```
- 根据int类型的属性对模型数组进行排序
```
NSArray *sortArrayByAgeInt = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {  
      
    Person *pModel1 = obj1;  
    Person *pModel2 = obj2;  
    
    if (pModel1.age > pModel2.age) { 
        return NSOrderedDescending;//降序  
    }else if (pModel1.name < pModel2.name){  
        return NSOrderedAscending;//升序  
    }else {  
        return NSOrderedSame;//相等  
    }  
      
}];
```
- 根据str类型的属性对模型数组进行排序
```
NSArray *sortArrayByIDStr = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {  
      
    Person *pModel1 = obj1;  
    Person *pModel2 = obj2;  
    
    if ([pModel1.ID intValue]> [pModel2.ID intValue]) { 
        return NSOrderedDescending;//降序  
    }else if (pModel1.name < pModel2.name){  
        return NSOrderedAscending;//升序  
    }else {  
        return NSOrderedSame;//相等  
    }  
      
}];
```
# 4. 花样玩法：例题
---
在OC的高级用法中，经常需要查看系统类或者某个自定义类中的私有属性以及私有成员变量，并通过KVC的办法强制修改这些私有成员变量的值，以取代系统或者自定义类中的默认设置。所以，如果你懒得创建一些假数据的数组，可以想到运用运行时的办法获取成员变量的数组，并进行排序操作训练。

> **题1**. 请取出`NSString`类的全部**公有** **属性** 并存放到一个数组，并利用`NSArray`的`sortedArrayUsingComparator`的方法给这个数组进行升序排序操作。要求：排序过程中需要区分字符全角半角状态，其它可按系统默认条件。

- 参考代码：
main.m
```
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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"handlePrintingOfProperties()**********************");
        handlePrintingOfProperties();
    }
    return 0;
}
```

- 运行结果

![image.png](https://github.com/cimain/MediaResourcesForNotes/blob/master/SortingForArray/s1.png?raw=true)


> **题2**. 请取出`NSURL`类中包括**私有** 在内的**全部** **成员变量**，并存放到一个数组，并利用`NSArray`的`sortedArrayUsingComparator`的方法给这个数组进行升序排序操作。要求：排序过程中需要区分字符全角半角状态，其它可按系统默认条件。

- 参考代码：
```
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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"handlePrintingOfIvars()**********************");
        handlePrintingOfIvars();
    }
    return 0;
}
```

- 运行结果

![image.png](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5be3766c71?w=1182&h=502&f=png&s=82314)



# 5. 附录：本实验中创建工程说明
---
任何能在计算机上执行的项目称之为**程序**，其中，有图形化用户界面的程序称之为**应用** ，没有图形界面的程序可以是**守护进程** ，还有一种称之为**命令行工具**。本文这里关注的是算法和数据结果，不关注图形界面，所以新建一个命令行工具即可。创建方法：新建一个macOS工程，选择Command Line Tool类型，点击下一步配置工程信息即可。

![创建一个命令行工具](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5be4e47d99?w=1240&h=952&f=png&s=192239)

![工程创建成功](https://user-gold-cdn.xitu.io/2018/4/12/162b7d5be78cfc44?w=1240&h=804&f=png&s=367110)

