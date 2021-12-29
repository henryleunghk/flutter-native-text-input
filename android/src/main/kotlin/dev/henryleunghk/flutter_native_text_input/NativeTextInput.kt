package dev.henryleunghk.flutter_native_text_input

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.os.Build
import android.text.InputType
import android.view.Gravity
import android.view.View
import android.widget.EditText
import androidx.annotation.RequiresApi
import io.flutter.plugin.platform.PlatformView

internal class NativeTextInput(context: Context, id: Int, creationParams: Map<String?, Any?>) : PlatformView {
    private val editText: EditText

    override fun getView(): View {
        return editText
    }

    override fun dispose() {}

    init {
        editText = EditText(context)
        editText.setBackgroundResource(R.drawable.edit_text_background)
        editText.setTextCursorDrawable(R.drawable.edit_text_cursor)

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
            editText.textSize = fontSize.toFloat()
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

        editText.maxLines = creationParams.get("maxLines") as Int

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
    }
}