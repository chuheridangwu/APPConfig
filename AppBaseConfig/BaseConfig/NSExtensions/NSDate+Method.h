//
//  NSDate+Method.h
//  CategoryProject
//
//  Created by mlive on 2021/4/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Method)
@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL isLeapMonth; ///< whether the month is leap month
@property (nonatomic, readonly) BOOL isLeapYear; ///< whether the year is leap year
@property (nonatomic, readonly) BOOL isToday; ///< whether date is today (based on current locale)
@property (nonatomic, readonly) BOOL isYesterday; ///< whether date is yesterday (based on current locale)

/**是否为同一天*/
+ (BOOL)mm_isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

/**
 返回一个日期，该日期表示接收者的日期，该日期以后再偏移提供的天数。

   @param days  添加的天数。
   @return  日期由所需天数修改。
 */
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

/**
 返回表示该日期的格式化字符串。参见http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html
  
   @param format    表示所需日期格式的字符串。 例如 @“ yyyy-MM-dd HH：mm：ss”
   @return NSString表示格式化的日期字符串。
 */
- (nullable NSString *)stringWithFormat:(NSString *)format;
@end

NS_ASSUME_NONNULL_END
