import 'dart:io';
import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final bool showStar;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onTap,
    this.showStar = false,
  });

  Color _avatarColor() {
    final colors = [
      const Color(0xFF7C4DFF),
      const Color(0xFF2196F3),
      const Color(0xFF4CAF91),
      const Color(0xFFFF8A3D),
      const Color(0xFFE85D9E),
      const Color(0xFF26AFC3),
    ];

    if (contact.name.isEmpty) {
      return colors[0];
    }

    final index =
        contact.name.toUpperCase().codeUnitAt(0) % colors.length;

    return colors[index];
  }

  String _initials() {
    final words = contact.name.trim().split(' ');

    if (words.length >= 2 && words.first.isNotEmpty && words.last.isNotEmpty) {
      return '${words.first[0]}${words.last[0]}'.toUpperCase();
    }

    if (words.isNotEmpty && words.first.isNotEmpty) {
      return words.first[0].toUpperCase();
    }

    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.05),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: _avatarColor(),
                backgroundImage: contact.imagePath != null
                    ? FileImage(File(contact.imagePath!))
                    : null,
                child: contact.imagePath == null
                    ? Text(
                        _initials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),

                    const SizedBox(height: 2),

                    if (contact.email.isNotEmpty)
                      Text(
                        contact.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),

                    Text(
                      contact.phone,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              if (showStar)
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                )
              else
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
