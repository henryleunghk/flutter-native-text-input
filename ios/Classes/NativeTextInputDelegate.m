#import "NativeTextInputDelegate.h"

@implementation NativeTextInputDelegate {
    FlutterMethodChannel* _channel;
    id _Nullable _args;
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args {
    self = [super init];
    if (self) {
        _channel = channel;
        _args = args;
    }
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:_args[@"placeholder"]]) {
        textView.text = @"";
        textView.textColor = UIColor.blackColor;
    }
    [_channel invokeMethod:@"inputStarted"
                 arguments:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    textView.textColor = textView.text == 0 ? UIColor.lightTextColor : UIColor.blackColor;
    [_channel invokeMethod:@"inputValueChanged" arguments:@{ @"text" : textView.text }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = _args[@"placeholder"];
        textView.textColor = UIColor.lightGrayColor;
    }
    [_channel invokeMethod:@"inputFinished"
                 arguments:@{ @"text": textView.text }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (
        textView.textContainer.maximumNumberOfLines == 1 &&
        [text isEqualToString:@"\n"]
    ) {
        [textView resignFirstResponder];
        return false;
    } else if (textView.textContainer.maximumNumberOfLines == 0) {
        return true;
    } else {
        NSUInteger existingLines = [textView.text componentsSeparatedByString:@"\n"].count;
        NSUInteger newLines = [text componentsSeparatedByString:@"\n"].count;
        NSUInteger linesAfterChange = existingLines + newLines - 1;
        return linesAfterChange <= textView.textContainer.maximumNumberOfLines;
    }
}

@end
