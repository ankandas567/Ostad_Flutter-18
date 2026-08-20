import 'dart:io';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/contact.dart';
import 'edit_contact_screen.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailsScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ContactDetailsScreen> createState() =>
      _ContactDetailsScreenState();
}

class _ContactDetailsScreenState
    extends State<ContactDetailsScreen> {
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _editContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditContactScreen(
          contact: _contact,
        ),
      ),
    );

    if (result == true) {
      final updated =
      await DatabaseHelper.instance
          .getContactById(_contact.id!);

      if (updated != null && mounted) {
        setState(() {
          _contact = updated;
        });
      }
    }
  }

  Future<void> _deleteContact() async {
    final confirmed =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delete Contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete\n${_contact.name}?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await DatabaseHelper.instance
        .deleteContact(_contact.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Contact deleted successfully!',
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  Color _avatarColor() {
    final colors = [
      const Color(0xFF7C4DFF),
      const Color(0xFF2196F3),
      const Color(0xFF4CAF91),
      const Color(0xFFFF8A3D),
      const Color(0xFFE85D9E),
      const Color(0xFF26AFC3),
    ];

    if (_contact.name.isEmpty) {
      return colors[0];
    }

    final index =
        _contact.name.toUpperCase().codeUnitAt(0) % colors.length;

    return colors[index];
  }

  String _getInitials() {
    final words =
    _contact.name.trim().split(' ');

    if (words.length >= 2 && words.first.isNotEmpty && words.last.isNotEmpty) {
      return '${words.first[0]}${words.last[0]}'
          .toUpperCase();
    }

    if (words.isNotEmpty && words.first.isNotEmpty) {
      return words.first[0].toUpperCase();
    }

    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            onPressed: _editContact,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _deleteContact,
            icon: const Icon(Icons.delete_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),

            CircleAvatar(
              radius: 50,
              backgroundColor: _avatarColor(),
              backgroundImage: _contact.imagePath != null
                  ? FileImage(File(_contact.imagePath!))
                  : null,
              child: _contact.imagePath == null
                  ? Text(
                      _getInitials(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 20),

            Text(
              _contact.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.phone,
                      title: _contact.phone,
                      subtitle: 'Mobile',
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.email,
                      title: _contact.email,
                      subtitle: 'Email',
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      title: _contact.address,
                      subtitle: 'Address',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 24),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? 'Not provided' : title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 64,
      endIndent: 20,
      color: Theme.of(context).dividerColor.withOpacity(0.05),
    );
  }
}
