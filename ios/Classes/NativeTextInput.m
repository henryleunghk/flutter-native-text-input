#import "NativeTextInput.h"
#import "NativeTextInputDelegate.h"

@interface UITextView(Placeholder)
@property(nullable, nonatomic, copy) NSAttributedString *attributedPlaceholder;
@end

@implementation NativeInputField {
    UITextView* _textView;
    
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    NativeTextInputDelegate* _delegate;
    id _Nullable _args;
    
    float _containerWidth;
}


- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    
    if ([super init]) {
        NSString* channelName = [NSString stringWithFormat:@"flutter_native_text_input%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        _viewId = viewId;
        _args = args;
        
        _textView = [[UITextView alloc] initWithFrame:frame];
        _textView.backgroundColor = UIColor.clearColor;
        _textView.keyboardAppearance = [self keyboardAppearanceFromString:args[@"keyboardAppearance"]];
        _textView.keyboardType = [self keyboardTypeFromString:args[@"keyboardType"]];
        _textView.returnKeyType = [self returnKeyTypeFromString:args[@"returnKeyType"]];
        _textView.textAlignment = [self textAlignmentFromString:args[@"textAlign"]];
        _textView.autocapitalizationType = [self textAutocapitalizationTypeFromString:args[@"textCapitalization"]];
        _textView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
        
        if ([args[@"maxLines"] intValue] == 1) {
            _textView.textContainer.maximumNumberOfLines = 1;
        }
        float minHeightPadding = [args[@"minHeightPadding"] floatValue];
        [_textView setTextContainerInset: UIEdgeInsetsMake(minHeightPadding / 2, 0, minHeightPadding / 2, 0)];
        if (@available(iOS 10.0, *)) {
            _textView.textContentType = [self textContentTypeFromString:args[@"textContentType"]];
        }
        if (args[@"cursorColor"] && ![args[@"cursorColor"] isKindOfClass:[NSNull class]]) {
            NSDictionary* fontColor = args[@"cursorColor"];
            _textView.tintColor = [UIColor colorWithRed:[fontColor[@"red"] floatValue]/255.0 green:[fontColor[@"green"] floatValue]/255.0 blue:[fontColor[@"blue"] floatValue]/255.0 alpha:[fontColor[@"alpha"] floatValue]/255.0];
        }
        if (args[@"autocorrect"] && ![args[@"autocorrect"] isKindOfClass:[NSNull class]]) {
            _textView.autocorrectionType = [args[@"autocorrect"] boolValue]
              ? UITextAutocorrectionTypeYes
              : UITextAutocorrectionTypeNo;
        }

        _delegate = [[NativeTextInputDelegate alloc] initWithChannel:_channel arguments:args ];
        _textView.delegate = _delegate;
        
        _textView.text = args[@"text"];
        _textView.textColor = _delegate.fontColor;
        _textView.font = _delegate.font;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        if (args[@"placeholder"] && ![args[@"placeholder"] isKindOfClass:[NSNull class]]) {
            if (_delegate.placeholderFont) {
                [attributes setObject:_delegate.placeholderFont forKey:NSFontAttributeName];
            }
            if (_delegate.placeholderFontColor) {
                [attributes setObject:_delegate.placeholderFontColor forKey:NSForegroundColorAttributeName];
            }
            _textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:args[@"placeholder"]
                                                                              attributes:attributes];
        }

        if ([args[@"onTap"] boolValue]) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:_delegate
                                                                                        action:@selector(singleTapRecognized:)];
            singleTap.delegate = _delegate;
            singleTap.numberOfTapsRequired = 1;
            [_textView addGestureRecognizer:singleTap];
        }

        _containerWidth = [args[@"width"] floatValue];
        
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
    }
    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"getContentHeight"]) {
        CGSize boundSize = CGSizeMake(_containerWidth, MAXFLOAT);
        CGSize size = [_textView sizeThatFits: boundSize];
        result([NSNumber numberWithFloat: size.height]);
    } else if ([[call method] isEqualToString:@"getLineHeight"]) {
        result([NSNumber numberWithFloat: _textView.font.lineHeight]);
    } else if ([[call method] isEqualToString:@"unfocus"]) {
        [self onUnFocus:call result:result];
    } else if ([[call method] isEqualToString:@"focus"]) {
        [self onFocus:call result:result];
    } else if ([[call method] isEqualToString:@"setText"]) {
        [self onSetText:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)onFocus:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_textView becomeFirstResponder];
    result(nil);
}

- (void)onUnFocus:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_textView resignFirstResponder];

    result(nil);
}

- (void)onSetText:(FlutterMethodCall*)call result:(FlutterResult)result {
    _textView.text = call.arguments[@"text"];
    _textView.textColor = _delegate.fontColor;
    _textView.font = _delegate.font;
    
    if (_textView.textContainer.maximumNumberOfLines == 1) {
        _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    result(nil);
}

- (UIView*)view {
    return _textView;
}

- (UIKeyboardAppearance)keyboardAppearanceFromString:(NSString*)keyboardAppearance {
    if (!keyboardAppearance || [keyboardAppearance isKindOfClass:[NSNull class]]) {
        return UIKeyboardAppearanceDefault;
    }
    if ([keyboardAppearance isEqualToString:@"Brightness.dark"]) {
        return UIKeyboardAppearanceDark;
    } else if ([keyboardAppearance isEqualToString:@"Brightness.light"]) {
        return UIKeyboardAppearanceLight;
    }

    return UIKeyboardAppearanceDefault;
}

- (UIKeyboardType)keyboardTypeFromString:(NSString*)keyboardType {
    if (!keyboardType || [keyboardType isKindOfClass:[NSNull class]]) {
        return UIKeyboardTypeDefault;
    }
    
    if ([keyboardType isEqualToString:@"KeyboardType.asciiCapable"]) {
        return UIKeyboardTypeASCIICapable;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.numbersAndPunctuation"]) {
        return UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.url"]) {
        return UIKeyboardTypeURL;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.numberPad"]) {
        return UIKeyboardTypeNumberPad;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.phonePad"]) {
        return UIKeyboardTypePhonePad;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.namePhonePad"]) {
        return UIKeyboardTypeNamePhonePad;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.emailAddress"]) {
        return UIKeyboardTypeEmailAddress;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.decimalPad"]) {
        return UIKeyboardTypeDecimalPad;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.twitter"]) {
        return UIKeyboardTypeTwitter;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.webSearch"]) {
        return UIKeyboardTypeWebSearch;
    }
    else if ([keyboardType isEqualToString:@"KeyboardType.asciiCapableNumberPad"]) {
        if (@available(iOS 10.0, *)) {
            return UIKeyboardTypeASCIICapableNumberPad;
        } else {
            return UIKeyboardTypeNumberPad;
        }
    }
    
    return UIKeyboardTypeDefault;
}

- (UIReturnKeyType)returnKeyTypeFromString:(NSString *)returnKeyType {
    if (!returnKeyType || [returnKeyType isKindOfClass:[NSNull class]]) {
        return UIReturnKeyDefault;
    }
    
    if ([returnKeyType isEqualToString:@"ReturnKeyType.defaultAction"]) {
        return UIReturnKeyDefault;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.go"]) {
        return UIReturnKeyGo;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.google"]) {
        return UIReturnKeyGoogle;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.join"]) {
        return UIReturnKeyJoin;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.next"]) {
        return UIReturnKeyNext;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.route"]) {
        return UIReturnKeyRoute;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.search"]) {
        return UIReturnKeySearch;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.send"]) {
        return UIReturnKeySend;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.yahoo"]) {
        return UIReturnKeyYahoo;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.done"]) {
        return UIReturnKeyDone;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.emergencyCall"]) {
        return UIReturnKeyEmergencyCall;
    } else if ([returnKeyType isEqualToString:@"ReturnKeyType.continueAction"]) {
        return UIReturnKeyContinue;
    }
    
    return UIReturnKeyDefault;
}

- (UITextAutocapitalizationType)textAutocapitalizationTypeFromString:(NSString *)textCapitalization {
    if (!textCapitalization || [textCapitalization isKindOfClass:[NSNull class]]) {
        return UITextAutocapitalizationTypeNone;
    }
    
    if ([textCapitalization isEqualToString:@"TextCapitalization.none"]) {
        return UITextAutocapitalizationTypeNone;
    } else if ([textCapitalization isEqualToString:@"TextCapitalization.characters"]) {
        return UITextAutocapitalizationTypeAllCharacters;
    } else if ([textCapitalization isEqualToString:@"TextCapitalization.sentences"]) {
        return UITextAutocapitalizationTypeSentences;
    } else if ([textCapitalization isEqualToString:@"TextCapitalization.words"]) {
        return UITextAutocapitalizationTypeWords;
    }
    
    return UITextAutocapitalizationTypeNone;
}

- (UITextContentType)textContentTypeFromString:(NSString *)contentType {
    if (!contentType || [contentType isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if (@available(iOS 10.0, *)) {
        
        if ([contentType isEqualToString:@"TextContentType.username"]) {
            if (@available(iOS 11.0, *)) {
                return UITextContentTypeUsername;
            } else {
                return nil;
            }
        }
        
        if ([contentType isEqualToString:@"TextContentType.password"]) {
            if (@available(iOS 11.0, *)) {
                return UITextContentTypePassword;
            } else {
                return nil;
            }
        }
        
        if ([contentType isEqualToString:@"TextContentType.newPassword"]) {
            if (@available(iOS 12.0, *)) {
                return UITextContentTypeNewPassword;
            } else if (@available(iOS 11.0, *)) {
                return UITextContentTypePassword;
            } else {
                return nil;
            }
        }
        
        if ([contentType isEqualToString:@"TextContentType.oneTimeCode"]) {
            if (@available(iOS 12.0, *)) {
                return UITextContentTypeOneTimeCode;
            } else {
                return nil;
            }
        }
        
        NSDictionary *dict =
        @{
          @"TextContentType.name":                  UITextContentTypeName,
          @"TextContentType.namePrefix":            UITextContentTypeNamePrefix,
          @"TextContentType.givenName":             UITextContentTypeGivenName,
          @"TextContentType.middleName":            UITextContentTypeMiddleName,
          @"TextContentType.familyName":            UITextContentTypeFamilyName,
          @"TextContentType.nameSuffix":            UITextContentTypeNameSuffix,
          @"TextContentType.nickname":              UITextContentTypeNickname,
          @"TextContentType.jobTitle":              UITextContentTypeJobTitle,
          @"TextContentType.organizationName":      UITextContentTypeOrganizationName,
          @"TextContentType.location":              UITextContentTypeLocation,
          @"TextContentType.fullStreetAddress":     UITextContentTypeFullStreetAddress,
          @"TextContentType.streetAddressLine1":    UITextContentTypeStreetAddressLine1,
          @"TextContentType.streetAddressLine2":    UITextContentTypeStreetAddressLine2,
          @"TextContentType.city":                  UITextContentTypeAddressCity,
          @"TextContentType.addressState":          UITextContentTypeAddressState,
          @"TextContentType.addressCityAndState":   UITextContentTypeAddressCityAndState,
          @"TextContentType.sublocality":           UITextContentTypeSublocality,
          @"TextContentType.countryName":           UITextContentTypeCountryName,
          @"TextContentType.postalCode":            UITextContentTypePostalCode,
          @"TextContentType.telephoneNumber":       UITextContentTypeTelephoneNumber,
          @"TextContentType.emailAddress":          UITextContentTypeEmailAddress,
          @"TextContentType.url":                   UITextContentTypeURL,
          @"TextContentType.creditCardNumber":      UITextContentTypeCreditCardNumber
          };
        
        return dict[contentType];
    } else {
        return nil;
    }
}

- (NSTextAlignment)textAlignmentFromString:(NSString*)textAlignment {
    if (!textAlignment || [textAlignment isKindOfClass:[NSNull class]]) {
        return NSTextAlignmentNatural;
    }
    
    if ([textAlignment isEqualToString:@"TextAlign.left"]) {
        return NSTextAlignmentLeft;
    } else if ([textAlignment isEqualToString:@"TextAlign.right"]) {
        return NSTextAlignmentRight;
    } else if ([textAlignment isEqualToString:@"TextAlign.center"]) {
        return NSTextAlignmentCenter;
    } else if ([textAlignment isEqualToString:@"TextAlign.justify"]) {
        return NSTextAlignmentJustified;
    } else if ([textAlignment isEqualToString:@"TextAlign.end"]) {
        return ([self layoutDirection] == UIUserInterfaceLayoutDirectionLeftToRight)
            ? NSTextAlignmentRight
            : NSTextAlignmentLeft;
    }
    
    // TextAlign.start
    return NSTextAlignmentNatural;
}

- (UIUserInterfaceLayoutDirection)layoutDirection {
    if (@available(iOS 9.0, *)) {
        return [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:_textView.semanticContentAttribute];
    }
    
    return UIApplication.sharedApplication.userInterfaceLayoutDirection;
}

@end
