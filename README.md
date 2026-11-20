# Mystsriya

Mystsriya is a Flutter mobile app that lets users earn money by joining brand
campaigns, completing small tasks (sharing and reviewing products), and getting
paid into their bank account. It also has a social feed where users post about
products, like, and comment.

Android package: `com.mystsriya` · Version: `1.1.9+17`

Play Store: https://play.google.com/store/apps/details?id=com.mystsriya

---

## Features

- **Onboarding**: three intro slides on first launch, then login / register.
- **Authentication**: email + password, Google Sign-In, Sign in with Apple.
  Forgot password flow with email verification and OTP, change password,
  delete account.
- **Campaigns**: browse active campaigns with filters, view campaign details
  (brand, payout, slots, joined users), apply, and work through the campaign's
  task list. Each task can be submitted with proof, reviewed, rejected with a
  reason, and resubmitted. Past campaigns are listed separately.
- **Discover feed**: create image or text posts, edit or delete your own posts,
  like and comment on others, view a user's posts.
- **Earnings / Wallet**: wallet transaction history, add or update bank account
  details for payouts, refer-and-earn screen with share link.
- **Profile**: view and edit profile, notifications screen.
- **Push notifications** via Firebase Cloud Messaging, including background
  messages.

## Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter (Dart SDK `>=2.19 <3.0`) |
| State / architecture | `StatefulWidget` screens calling plain service classes; no state-management package |
| Networking | `http` and `dio` against a Laravel REST backend |
| Local storage | `shared_preferences` (auth token, user id, name, image, login flag) |
| Auth providers | `firebase_auth`, `google_sign_in`, `sign_in_with_apple` |
| Push | `firebase_messaging`, `flutter_local_notifications` |
| Media | `image_picker`, `file_picker`, `video_player`, `cached_network_image`, `screenshot`, `share_plus` |
| UI helpers | `card_swiper`, `intro_slider`, `otp_text_field`, `percent_indicator`, `avatar_stack`, `flutter_html`, `fluttertoast`, `rflutter_alert` |
| Fonts | Lexend, Futura (bundled in `assets/font/`) |

## Backend API

The app is a client only. It talks to a Laravel API hosted at
`https://nivethaeacademy.in/mystsriya/public/api`. Main endpoints used:

| Purpose | Endpoint |
| --- | --- |
| Auth | `login`, `glogin`, `signup`, `verify-email`, `verify-otp`, `forgot/change_password`, `change_password`, `user-detail` |
| Campaigns | `campaigns`, `campaigns/{id}`, `campaigns/apply/{id}`, `campaigns/finish/{id}`, `campaigns/pastCampaigns`, `tasks`, `tasks/{id}` |
| Posts | `posts`, `posts?page=`, `posts/{id}`, `posts/update/{id}`, `posts/likes/{id}`, `posts/comment/{id}` |
| Profile | `profile`, `profile/wallet` |

Uploaded media is served from `.../mystsriya/public/storage/`. Requests send
the bearer token stored in shared preferences; a `401` triggers
`Utils.logout()` which clears the session and returns to the login screen.

## Code structure

```
lib/
├── main.dart                     # Firebase init, FCM background handler, MaterialApp
├── SplashScreen.dart             # Reads prefs, routes to Intro / Login / Home tabs
├── Screen/
│   ├── IntroPage.dart            # First-launch intro slider
│   ├── auth/                     # Login, Register, Forgot/Reset password,
│   │                             # Change password, Add bank account
│   ├── main/                     # Dashboard, Campaigns (list, filter, details,
│   │                             # task details, my/past campaigns), Posts
│   │                             # (create, edit, user posts, blog details),
│   │                             # Wallet, Bank details, Profile, Edit profile,
│   │                             # Notifications, Refer & earn, Delete account,
│   │                             # Colors.dart (app palette)
│   └── widgets/
│       ├── custom_bottom_tab_bar.dart   # Home / Campaigns / Earnings / Profile tabs
│       └── complet_task_dialog.dart     # Task submission dialog
├── services/                     # One class per API area; each method calls the
│   ├── auth_services.dart        # backend and returns a typed model
│   ├── campaigns_services.dart
│   ├── comment_services.dart
│   ├── create_post_services.dart
│   ├── dashboard_services.dart
│   ├── profile_services.dart
│   └── user_post_services.dart
├── models/                       # JSON response models (fromJson / toJson)
│   ├── common_auth_model.dart
│   ├── common_campaigns_model.dart
│   ├── common_comment_model.dart
│   ├── common_dashboard_model.dart
│   ├── common_profile_model.dart
│   └── wallet_model.dart
└── utils/
    └── utils.dart                # Shared prefs holder, API logging, logout,
                                  # password validator, timeAgo, input borders

assets/
├── images/                       # Icons, logos, intro slides
└── font/                         # Lexend_Regular.ttf, Futura_book_Italic_font.ttf

android/, ios/, macos/, windows/, linux/, web/   # Flutter platform runners
```

### How a screen talks to the backend

1. A screen in `Screen/` collects input and calls a method on a service class,
   for example `CampaignsServices().campaignsListData(...)`.
2. The service builds the URL, attaches the bearer token from
   `Utils.prefs`, sends the request, and logs it through `Utils.logApiData`.
3. The JSON response is parsed into a model from `models/` and returned to the
   screen, which calls `setState` to render it.

### App flow

```
SplashScreen
 ├─ loginStatus == true  → CustomBottomTabBar (Home, Campaigns, Earnings, Profile)
 ├─ firstTime == true    → IntroPage → LoginHomeScreen
 └─ otherwise            → LoginHomeScreen
```

### Naming note

Several screens exist in two versions, for example `LoginScreen` and
`LoginNewScreen`, `CampaignsScreen` and `CampaignsScreenNew`. The `New`
variants are the ones wired into navigation; the older files are kept from the
previous design and can be removed once confirmed unused.

## Getting started

Prerequisites: Flutter SDK (stable), Android Studio or Xcode, a Firebase
project for this app.

```bash
flutter pub get
flutter run
```

### Files you must add locally (not in the repo)

These are ignored by `.gitignore` because they are secrets:

| File | Purpose |
| --- | --- |
| `android/app/google-services.json` | Firebase config for Android |
| `ios/Runner/GoogleService-Info.plist` | Firebase config for iOS |
| `android/key.properties` | Keystore path, alias, and passwords for release signing |
| `android/app/*.jks` | Release signing keystore |

Without the Firebase files the app will fail at `Firebase.initializeApp()` on
startup.

### Release build

```bash
flutter build apk --release
flutter build appbundle --release
```

Signing is configured in `android/app/build.gradle` and reads
`android/key.properties`.

## Known issues / TODO

- `main.dart` installs an `HttpOverrides` that accepts any TLS certificate.
  This should be removed before a production release.
- Duplicate "old vs New" screens should be cleaned up.
- The backend base URL is hardcoded in each service file; moving it to a single
  constants file would make environment switching easier.
- Font declarations in `pubspec.yaml` are duplicated (one block commented out).
