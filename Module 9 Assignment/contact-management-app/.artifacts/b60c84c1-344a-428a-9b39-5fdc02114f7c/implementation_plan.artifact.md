# Refine UI to Match Reference

The goal is to update the current Flutter application to more closely match the design guidelines provided in the reference UI image. This includes adding a navigation drawer, refining screen layouts, and adding a settings page.

## User Review Required

> [!NOTE]
> The app will now feature a navigation drawer for better navigation between "All Contacts", "Favorites", and "Add Contact".

## Proposed Changes

### [UI Components]

#### [MODIFY] [main.dart](file:///F:/Course/Ostad_Flutter-18/Module%209%20Assignment/contact-management-app/lib/main.dart)
- Update theme to match the purple color palette of the reference.
- Add support for Dark/Light mode (bonus).

#### [MODIFY] [contact_list_screen.dart](file:///F:/Course/Ostad_Flutter-18/Module%209%20Assignment/contact-management-app/lib/screens/contact_list_screen.dart)
- Implement a `Drawer` with options: My Contacts, Favorites, Add Contact, About, Settings, Logout.
- Refine `ListTile` to show name, email, and phone number in a layout similar to the reference.
- Add an empty state widget with an icon/illustration.

#### [MODIFY] [add_edit_contact_screen.dart](file:///F:/Course/Ostad_Flutter-18/Module%209%20Assignment/contact-management-app/lib/screens/add_edit_contact_screen.dart)
- Add a circular avatar placeholder with a camera icon at the top.
- Add icons to the text input fields.
- Update button style to match the reference.

#### [MODIFY] [contact_details_screen.dart](file:///F:/Course/Ostad_Flutter-18/Module%209%20Assignment/contact-management-app/lib/screens/contact_details_screen.dart)
- Redesign the header with a solid background and a large avatar.
- Use a cleaner layout for contact details with icons.

#### [NEW] [settings_screen.dart](file:///F:/Course/Ostad_Flutter-18/Module%209%20Assignment/contact-management-app/lib/screens/settings_screen.dart)
- Simple settings page with Theme toggle and version info.

## Verification Plan

### Automated Tests
- N/A (UI focused)

### Manual Verification
- Verify the Navigation Drawer opens and routes correctly.
- Verify the Contact List items display Name, Phone, and Email.
- Verify the Add/Edit screen looks like the reference mockup.
- Verify the Details screen matches the reference.
- Toggle Light/Dark mode in settings.
