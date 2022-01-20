package dev.henryleunghk.flutter_native_text_input

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.os.Build
import android.text.InputType
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import androidx.annotation.NonNull
import androidx.core.widget.doOnTextChanged
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

val TAG: String = "NativeTextInput"

internal class NativeTextInput(context: Context, id: Int, creationParams: Map<String?, Any?>, channel: MethodChannel) : PlatformView, MethodChannel.MethodCallHandler {
    private val context: Context
    private val scaledDensity: Float
    private val editText: EditText

    override fun getView(): View {
        return editText
    }

    override fun dispose() {}

    init {
        this.context = context
        scaledDensity = context.resources.displayMetrics.scaledDensity

        editText = EditText(context)
        editText.setBackgroundResource(R.drawable.edit_text_background)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            editText.setTextCursorDrawable(R.drawable.edit_text_cursor)
        }

        if (creationParams.get("fontColor") != null) {
            val rgbMap = creationParams.get("fontColor") as Map<String, Float>
            val color = Color.argb(
                    rgbMap.get("alpha") as Int,
                    rgbMap.get("red") as Int,
                    rgbMap.get("green") as Int,
                    rgbMap.get("blue") as Int)
            editText.setTextColor(color)
        }

        if (creationParams.get("fontSize") != null) {
            val fontSize = creationParams.get("fontSize") as Double
            Log.d(TAG, "fontSize:" + fontSize)
            editText.setTextSize(TypedValue.COMPLEX_UNIT_SP, fontSize.toFloat())
            editText.textSize = fontSize.toFloat()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                editText.lineHeight = fontSize.toInt()
            }
        }

        if (creationParams.get("fontWeight") != null &&
                android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
            val fontWeight = creationParams.get("fontWeight") as String
            if (fontWeight == "FontWeight.w100") {
                editText.typeface = Typeface.create(editText.typeface, 100, false)
            } else if (fontWeight == "FontWeight.w200") {
                editText.typeface = Typeface.create(editText.typeface, 200, false)
            } else if (fontWeight == "FontWeight.w300") {
                editText.typeface = Typeface.create(editText.typeface, 300, false)
            } else if (fontWeight == "FontWeight.w400") {
                editText.typeface = Typeface.create(editText.typeface, 400, false)
            } else if (fontWeight == "FontWeight.w500") {
                editText.typeface = Typeface.create(editText.typeface, 500, false)
            } else if (fontWeight == "FontWeight.w600") {
                editText.typeface = Typeface.create(editText.typeface, 600, false)
            } else if (fontWeight == "FontWeight.w700") {
                editText.typeface = Typeface.create(editText.typeface, 700, false)
            } else if (fontWeight == "FontWeight.w800") {
                editText.typeface = Typeface.create(editText.typeface, 800, false)
            } else if (fontWeight == "FontWeight.w900") {
                editText.typeface = Typeface.create(editText.typeface, 900, false)
            }
        }

        val minLines = creationParams.get("minLines") as Int
        editText.minLines = minLines
        editText.setLines(minLines)

        val maxLines = creationParams.get("maxLines") as Int
        if (maxLines > minLines) {
            editText.maxLines = maxLines
        } else {
            editText.maxLines = minLines
        }

        val minHeightPadding = creationParams.get("minHeightPadding") as Double
        editText.setPadding(
            0,
            minHeightPadding.toInt() / 2,
            0,
            minHeightPadding.toInt() / 2)

        editText.hint = creationParams.get("placeholder") as String

        if (creationParams.get("placeholderFontColor") != null) {
            val rgbMap = creationParams.get("placeholderFontColor") as Map<String, Float>
            val color = Color.argb(
                    rgbMap.get("alpha") as Int,
                    rgbMap.get("red") as Int,
                    rgbMap.get("green") as Int,
                    rgbMap.get("blue") as Int)
            editText.setHintTextColor(color)
        }

        if (creationParams.get("returnKeyType") != null) {
            val returnKeyType = creationParams.get("returnKeyType") as String
            if (returnKeyType == "ReturnKeyType.go") {
                editText.imeOptions = EditorInfo.IME_ACTION_GO
            } else if (returnKeyType == "ReturnKeyType.next") {
                editText.imeOptions = EditorInfo.IME_ACTION_NEXT
            } else if (returnKeyType == "ReturnKeyType.search") {
                editText.imeOptions = EditorInfo.IME_ACTION_SEARCH
            } else if (returnKeyType == "ReturnKeyType.send") {
                editText.imeOptions = EditorInfo.IME_ACTION_SEND
            } else if (returnKeyType == "ReturnKeyType.done") {
                editText.imeOptions = EditorInfo.IME_ACTION_DONE
            }
        }

        if (creationParams.get("text") != null) {
            val text = creationParams.get("text") as String
            editText.setText(text)
        }

        if (creationParams.get("textAlign") != null) {
            val textAlign = creationParams.get("textAlign") as String
            if (textAlign == "TextAlign.left") {
                editText.gravity = Gravity.LEFT
            } else if (textAlign == "TextAlign.right") {
                editText.gravity = Gravity.RIGHT
            } else if (textAlign == "TextAlign.center") {
                editText.gravity = Gravity.CENTER
            } else if (textAlign == "TextAlign.justify") {
                editText.gravity = Gravity.FILL
            } else if (textAlign == "TextAlign.start") {
                editText.gravity = Gravity.START
            } else if (textAlign == "TextAlign.end") {
                editText.gravity = Gravity.END
            }
        }

        if (creationParams.get("textCapitalization") != null) {
            val textCapitalization = creationParams.get("textCapitalization") as String
            if (textCapitalization == "TextCapitalization.none") {
                editText.inputType = InputType.TYPE_CLASS_TEXT
            } else if (textCapitalization == "TextCapitalization.characters") {
                editText.inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS
            } else if (textCapitalization == "TextCapitalization.sentences") {
                editText.inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_SENTENCES
            } else if (textCapitalization == "TextCapitalization.words") {
                editText.inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_WORDS
            }
        }

        if (creationParams.get("keyboardType") != null) {
            val keyboardType = creationParams.get("keyboardType") as String
            if (keyboardType == "KeyboardType.numbersAndPunctuation" ||
                    keyboardType == "KeyboardType.numberPad" ||
                    keyboardType == "KeyboardType.asciiCapableNumberPad") {
                editText.inputType = InputType.TYPE_CLASS_NUMBER
            } else if (keyboardType == "KeyboardType.phonePad") {
                editText.inputType = InputType.TYPE_CLASS_PHONE
            } else if (keyboardType == "KeyboardType.decimalPad") {
                editText.inputType = InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
            } else if (keyboardType == "KeyboardType.url" ||
                    keyboardType == "KeyboardType.webSearch") {
                editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_URI
            } else if (keyboardType == "KeyboardType.emailAddress") {
                editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
            }
        } else if (creationParams.get("textContentType") != null) {
            val textContentType = creationParams.get("textContentType") as String
            if (textContentType == "TextContentType.username" ||
                    textContentType == "TextContentType.givenName" ||
                    textContentType == "TextContentType.middleName" ||
                    textContentType == "TextContentType.familyName" ||
                    textContentType == "TextContentType.nickname") {
                editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_PERSON_NAME
            } else if (textContentType == "TextContentType.password" ||
                    textContentType == "TextContentType.newPassword") {
                editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_PASSWORD
            } else if (textContentType == "TextContentType.fullStreetAddress" ||
                    textContentType == "TextContentType.streetAddressLine1" ||
                    textContentType == "TextContentType.streetAddressLine2" ||
                    textContentType == "TextContentType.addressCity" ||
                    textContentType == "TextContentType.addressState" ||
                    textContentType == "TextContentType.addressCityAndState") {
                editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_POSTAL_ADDRESS
            } else if (textContentType == "TextContentType.telephoneNumber") {
                editText.inputType = InputType.TYPE_CLASS_PHONE
            } else if (textContentType == "TextContentType.emailAddress") {
                editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
            } else if (textContentType == "TextContentType.url") {
                editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_URI
            }
        }

        val width = creationParams.get("width") as Double
        editText.maxWidth = width.toInt()

        if (minLines > 1 || maxLines > 1) {
            editText.inputType = editText.inputType or InputType.TYPE_TEXT_FLAG_MULTI_LINE
            editText.setHorizontallyScrolling(false)
        }

        editText.setOnFocusChangeListener { v, hasFocus ->
            Log.d(TAG, "hasFocus:" + hasFocus)
            if (hasFocus) {
                channel.invokeMethod("inputStarted", null)
            } else {
                channel.invokeMethod("inputFinished", mapOf("text" to editText.text.toString()))
            }
        }

        editText.doOnTextChanged { text, start, before, count ->
            Log.d(TAG, "doOnTextChanged:text:"+text.toString())
            Log.d(TAG, "doOnTextChanged:lineCount:"+editText.lineCount);
            channel.invokeMethod("inputValueChanged", mapOf("text" to text.toString()))
        }

        channel.setMethodCallHandler(this)
    }

    fun showKeyboard() {
        val inputMethodManager: InputMethodManager =
            context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        inputMethodManager.showSoftInput(editText, 0)
    }

    fun hideKeyboard() {
        val inputMethodManager =
            context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        inputMethodManager.hideSoftInputFromWindow(editText.windowToken, 0)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        if (call.method == "getContentHeight") {
            var contentHeight = editText.lineHeight / scaledDensity * editText.lineCount
            Log.d(TAG, "getContentHeight:" + contentHeight)
            result.success(contentHeight.toDouble())
        } else if (call.method == "getLineHeight") {
            val lineHeight = editText.textSize / scaledDensity
            Log.d(TAG, "getLineHeight:" + lineHeight)
            result.success(lineHeight.toDouble())
        } else if (call.method == "focus") {
            editText.requestFocus()
            showKeyboard()
        } else if (call.method == "unfocus") {
            editText.clearFocus()
            hideKeyboard()
        } else if (call.method == "setText") {
            val text = call.argument<String>("text")
            editText.setText(text)
        }
    }
}