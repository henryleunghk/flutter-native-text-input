package dev.henryleunghk.flutter_native_text_input

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeTextInputFactory(binding: FlutterPlugin.FlutterPluginBinding): PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var nativeTextInput: NativeTextInput
    private var messenger: BinaryMessenger

    init {
        messenger = binding.binaryMessenger
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>
        val channelName = "flutter_native_text_input${viewId}"
        channel = MethodChannel(messenger, channelName)

        return NativeTextInput(context, viewId, creationParams, channel)
    }
}