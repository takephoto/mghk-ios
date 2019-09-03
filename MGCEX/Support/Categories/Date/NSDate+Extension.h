
#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Extension)

+ (NSCalendar *) currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) dateTomorrow;//获取明天日期
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;//从现在开始往后推迟days天得到的时间戳
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;//从现在开始往前推days天得到的时间戳
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;//往后推多少小时的时间戳
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// 把字符串转换为时间戳（format格式的）,注意 前后格式一定要一致，否则转化失败
+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;

// 时间戳转化为字符串
- (NSString *) stringWithFormat: (NSString *) format;

- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
//以下是几种不同风格的时间戳转化为字符串的格式
@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;//是否与aDate时间戳在同一个天数,忽略时分秒

- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;

- (BOOL) isSameWeekAsDate: (NSDate *) aDate;//与aDate是否在同一个星期,上周星期7到这周星期6为一个星期
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;

- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isNextMonth;
- (BOOL) isLastMonth;

- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;

- (BOOL) isEarlierThanDate: (NSDate *) aDate;//比aDate时间戳早
- (BOOL) isLaterThanDate: (NSDate *) aDate;//比aDate时间戳迟

- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday; //是周末。6-7
- (BOOL) isTypicallyWeekend; //是工作日 1-5

//对象方法
- (NSDate *) dateByAddingYears: (NSInteger) dYears;//往后推N年
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;//往前推N年
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

// Date extremes
- (NSDate *) dateAtStartOfDay; //00:00:00
- (NSDate *) dateAtEndOfDay; //23:59:59

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate; //距离aDate超过了多少分钟
- (NSInteger) minutesBeforeDate: (NSDate *) aDate; //距离aDate提前了多少分钟
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// 获取年月日时分秒
@property (readonly) NSInteger nearestHour; //与那个小时最接近
@property (readonly) NSInteger hour; //获取时间戳的小时
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday; //获取时间戳是当前星期的第几个星期，从星期天开始
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;


- (NSDate *)dateWithYMD;
//字符串转时间戳
- (NSDate *)dateWithFormatter:(NSString *)formatter;

@end
