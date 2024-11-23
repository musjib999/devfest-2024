import 'dart:convert';

import 'package:benmore_challange/presentation/widgets/themes/themes.dart';
import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  final String profileImageUrl;
  final String username;
  final String date;
  final String postImageUrl;
  final String description;
  final Function(bool) onLike;
  final bool isLiked;
  final int likes;

  const PostItem({
    super.key,
    required this.profileImageUrl,
    required this.username,
    required this.date,
    required this.postImageUrl,
    required this.description,
    required this.likes,
    required this.onLike,
    required this.isLiked,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      widget.onLike(isLiked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppColors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: MemoryImage(
                    base64Decode(widget.profileImageUrl),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    Text(
                      widget.date,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.ash),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                  base64Decode(widget.postImageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildIconButton(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  isLiked ? Colors.red : Colors.black,
                  toggleLike,
                ),
                Text(widget.likes.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color iconColor, Function() ontap) {
    return IconButton(
      onPressed: ontap,
      icon: Icon(
        icon,
        color: iconColor,
        size: 20,
      ),
    );
  }
}
