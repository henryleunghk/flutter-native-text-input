#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeTextInputDelegate : NSObject <UITextViewDelegate>

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args;
- (float)fontSize;
- (UIColor *)fontColor;
- (float)placeholderFontSize;
- (UIColor *)placeholderFontColor;

@end

NS_ASSUME_NONNULL_END
