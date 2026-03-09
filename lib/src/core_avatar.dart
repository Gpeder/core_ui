import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

enum CoreAvatarImageType { network, asset, file, memory }

class CoreAvatar extends StatelessWidget {
  const CoreAvatar({
    super.key,
    required this.imageType,
    this.src,
    this.placeholder,
    this.size = const Size.square(40),
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.border,
    this.bytes,
  });

  //* Network
  const CoreAvatar.network(
    String this.src, {
    super.key,
    this.placeholder,
    this.size = const Size.square(40),
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.border,
    this.bytes,
  }) : imageType = CoreAvatarImageType.network;

  //* Asset
  const CoreAvatar.asset(
    String this.src, {
    super.key,
    this.placeholder,
    this.size = const Size.square(40),
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.border,
    this.bytes,
  }) : imageType = CoreAvatarImageType.asset;

  //* File
  const CoreAvatar.file(
    String this.src, {
    super.key,
    this.placeholder,
    this.size = const Size.square(40),
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.border,
    this.bytes,
  }) : imageType = CoreAvatarImageType.file;

  //* Memory (Uint8List)
  const CoreAvatar.memory(
    Uint8List this.bytes, {
    super.key,
    this.placeholder,
    this.size = const Size.square(40),
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.border,
    this.src,
  }) : imageType = CoreAvatarImageType.memory;

  final CoreAvatarImageType imageType;
  final String? src;
  final Uint8List? bytes;
  final Widget? placeholder;
  final Size size;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final BoxFit fit;
  final BoxBorder? border;

  ImageProvider? _resolveImage() {
    switch (imageType) {
      case CoreAvatarImageType.network:
        if (src == null) return null;
        return NetworkImage(src!);
      case CoreAvatarImageType.asset:
        if (src == null) return null;
        return AssetImage(src!);
      case CoreAvatarImageType.file:
        if (src == null) return null;
        return FileImage(File(src!));
      case CoreAvatarImageType.memory:
        if (bytes == null) return null;
        return MemoryImage(bytes!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? Theme.of(context).colorScheme.secondary;
    final imageProvider = _resolveImage();

    return Container(
      width: size.width,
      height: size.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bgColor,
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        border: border,
      ),
      child: imageProvider != null
          ? Image(
              image: imageProvider,
              width: size.width,
              height: size.height,
              fit: fit,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) return child;
                return placeholder ?? const SizedBox.shrink();
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: placeholder ?? const SizedBox.shrink(),
                );
              },
            )
          : Center(child: placeholder ?? const SizedBox.shrink()),
    );
  }
}
