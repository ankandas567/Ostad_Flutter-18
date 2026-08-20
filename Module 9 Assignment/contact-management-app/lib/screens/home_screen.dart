import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/contact.dart';
import '../widgets/contact_card.dart';
import 'add_contact_screen.dart';
import 'contact_details_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _database =
      DatabaseHelper.instance;

  final TextEditingController _searchController =
  TextEditingController();

  List<Contact> _contacts = [];

  bool _isLoading = true;
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();

    _loadContacts();

    _searchController.addListener(() {
      _loadContacts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });

    final query =
    _searchController.text.trim();

    List<Contact> contacts;

    if (_showFavoritesOnly) {
      contacts =
      await _database.getFavoriteContacts();

      if (query.isNotEmpty) {
        contacts = contacts
            .where(
              (contact) => contact.name
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
            .toList();
      }
    } else {
      if (query.isEmpty) {
        contacts =
        await _database.getContacts();
      } else {
        contacts =
        await _database.searchContacts(query);
      }
    }

    if (!mounted) return;

    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  Future<void> _addContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const AddContactScreen(),
      ),
    );

    if (result == true) {
      _loadContacts();
    }
  }

  Future<void> _openContact(Contact contact) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactDetailsScreen(
          contact: contact,
        ),
      ),
    );

    if (result == true) {
      _loadContacts();
    }
  }

  void _toggleFavoritesFilter() {
    setState(() {
      _showFavoritesOnly =
      !_showFavoritesOnly;
    });

    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showFavoritesOnly
              ? 'Favorites'
              : 'My Contacts',
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'favorites') {
                _toggleFavoritesFilter();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'favorites',
                child: Text(_showFavoritesOnly ? 'Show All' : 'Show Favorites'),
              ),
            ],
          ),
        ],
      ),

      drawer: _buildDrawer(),

      body: Column(
        children: [
          if (!_showFavoritesOnly)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 21,
                ),
                suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    _searchController
                        .clear();
                  },
                )
                    : null,
              ),
            ),
          ),

          Expanded(
            child: _buildContactList(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        backgroundColor:
        const Color(0xFF5146D8),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContactList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_contacts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadContacts,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          100,
        ),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];

          return ContactCard(
            contact: contact,
            onTap: () =>
                _openContact(contact),
            showStar: _showFavoritesOnly,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Image.network(
              'https://raw.githubusercontent.com/Ostad-Android-Flutter-Batch-1/Batch-1-Module-9-Assignment-UI/main/empty_contacts.png',
              height: 200,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.contacts, size: 80, color: Color(0xFF5146D8)),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              _showFavoritesOnly
                  ? 'No favorites yet'
                  : 'No contacts yet',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              _showFavoritesOnly
                  ? 'Mark contacts as favorite to see them here.'
                  : 'Add your first contact by tapping the + button below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              color: Color(0xFF5146D8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'My Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage your friends easily',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'My Contacts',
            isSelected: !_showFavoritesOnly,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _showFavoritesOnly = false;
              });
              _loadContacts();
            },
          ),

          _buildDrawerItem(
            icon: Icons.star_outline,
            title: 'Favorites',
            isSelected: _showFavoritesOnly,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _showFavoritesOnly = true;
              });
              _loadContacts();
            },
          ),

          _buildDrawerItem(
            icon: Icons.add_circle_outline,
            title: 'Add Contact',
            onTap: () {
              Navigator.pop(context);
              _addContact();
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Divider(height: 1),
          ),

          _buildDrawerItem(
            icon: Icons.info_outline,
            title: 'About App',
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Contact Management App',
                applicationVersion: '1.0.0',
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),

          const Spacer(),

          _buildDrawerItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: ListTile(
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: const Color(0xFFF0EFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF5146D8) : Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF5146D8) : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
