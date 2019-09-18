import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CircleAvatarIcon extends StatelessWidget {

  final String url;
  final double radius;
  double _pxRatio;

  CircleAvatarIcon({Key key, this.url, @required this.radius});

  @override
  Widget build(BuildContext context) {

    _pxRatio = MediaQuery.of(context).devicePixelRatio;

    return CircleAvatar(
      radius: radius * _pxRatio,
      backgroundColor: Colors.grey[100],
      backgroundImage: url != null ? CachedNetworkImageProvider(url) : null,
      child: url == null ? Icon(Icons.person, size: 12.0 * _pxRatio) : null,
    );
  }
}
