import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CircleAvatarIcon extends StatelessWidget {

  final String url;
  final double radius;

  CircleAvatarIcon({Key key, this.url, @required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[100],
      backgroundImage: url != null ? CachedNetworkImageProvider(url) : null,
      child: url == null ? Icon(Icons.person, size: 24.0) : null,
    );
  }
}
