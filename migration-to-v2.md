# Migrating to V2

Thanks for using this plugin and I hope you are happy using it so far.

## What's New

- Android support is added.

## How to Migrate

1. If you are using `cursorColor` and/or `keyboardAppearance`, they are wrapped in `iosOptions` now as these params are effective on iOS platform only
```
NativeTextInput(
  ..._otherConfigs,
  iosOptions: IosOptions(
    cursorColor: _cursoorColor,
    keyboardAppearance: _keyboardAppearance,
  ),
)
```

2. If you are using `placeholderStyle`, `placeholderColor` is extracted and the rest are moved inside `iosOptions`
```
NativeTextInput(
  ..._otherConfigs,
  placeholderColor: _placeholderColor,
  iosOptions: IosOptions(
    ..._otherOptions,
    placeholderStyle: TextStyle(
      fontSize: _placeholderFontSize,
      fontWeight: _placeholderFontWeight,
    ),
  ),
)
```

That's all. Enjoy!