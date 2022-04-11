#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeTextInputDelegate : NSObject <UITextViewDelegate, UIGestureRecognizerDelegate>

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args;
- (UIColor *)fontColor;
- (UIFont *)font;
- (UIColor *)placeholderFontColor;
- (UIFont *)placeholderFont;

@end

NS_ASSUME_NONNULL_END
