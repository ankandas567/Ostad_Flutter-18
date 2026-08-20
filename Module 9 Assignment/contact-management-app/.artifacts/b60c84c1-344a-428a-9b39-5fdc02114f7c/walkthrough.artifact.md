# Contact Management App Walkthrough

I have implemented a full-featured Flutter Contact Management App using `sqflite` for local data persistence. The app follows modern Material 3 design principles while staying true to the functional requirements of the reference UI.

## Features Implemented

- **Local Database Integration**: Used `sqflite` to store contact information persistently on the device.
- **Add & Edit Contacts**: A unified form to create new contacts or update existing ones, including fields for Name, Phone, Email, and Address.
- **Contact List**: A scrollable list of all contacts with quick-view details and favorite status indicators.
- **Contact Details**: A dedicated screen to view full contact details, with options to edit or delete.
- **Search Functionality**: Real-time search to find contacts by name.
- **Favorites System**: Bonus feature to mark contacts as favorites and filter the list to show only favorites.
- **Delete with Confirmation**: Safeguard to prevent accidental deletion of contacts.

## Technical Components

- **Model**: `Contact` class in `lib/models/contact.dart` with `toMap` and `fromMap` for database operations.
- **Database Helper**: `DatabaseHelper` in `lib/database/database_helper.dart` managing the SQLite database and CRUD operations.
- **Screens**:
    - `ContactListScreen`: The main hub for viewing and searching contacts.
    - `AddEditContactScreen`: Form for data entry and validation.
    - `ContactDetailsScreen`: Detailed view with management actions.

## Screenshots (Simulated)

The app features a clean, deep purple theme with Material 3 components, providing a professional and user-friendly experience.

### Main List & Search
Displays all contacts alphabetically with a floating action button to add new ones. The search bar allows filtering by name.

### Contact Form
Validates required fields (Name and Phone) and provides an easy-to-use interface for entering contact details.

### Details View
Shows all information for a contact and provides quick access to Edit and Delete actions.
