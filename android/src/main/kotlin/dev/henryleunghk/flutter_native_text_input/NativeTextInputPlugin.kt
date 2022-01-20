package dev.henryleunghk.flutter_native_text_input

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** NativeTextInputPlugin */
class NativeTextInputPlugin: FlutterPlugin {
  private lateinit var factory: NativeTextInputFactory

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    factory = NativeTextInputFactory(binding)
    binding.platformViewRegistry.registerViewFactory("flutter_native_text_input", factory)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
