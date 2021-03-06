#import "NativeTextInputDelegate.h"

@implementation NativeTextInputDelegate {
    FlutterMethodChannel* _channel;
    id _Nullable _args;
    CGRect _previousRect;
    int _currentLineIndex;
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args {
    self = [super init];
    if (self) {
        _channel = channel;
        _args = args;
        _previousRect = CGRectZero;
        _currentLineIndex = 1;
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
    UITextPosition *position = [textView endOfDocument];
    CGRect currentRect = [textView caretRectForPosition:position];
    
    if (_previousRect.origin.y == 0.0 ) { _previousRect = currentRect; }
    
    if (currentRect.origin.y > _previousRect.origin.y) {
        _currentLineIndex += 1;
    } else if (currentRect.origin.y < _previousRect.origin.y) {
        _currentLineIndex -= 1;
    }
    
    _previousRect = currentRect;
    
    textView.textColor = textView.text == 0 ? UIColor.lightTextColor : UIColor.blackColor;
    
    [_channel invokeMethod:@"inputValueChanged" arguments:@{ @"text": textView.text, @"currentLine": [NSNumber numberWithInt: _currentLineIndex] }];
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
