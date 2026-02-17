# Setup Checklist ✅

Use this checklist to track your setup progress!

## Prerequisites
- [x] Flutter SDK installed (`flutter doctor` runs successfully)
- [x] Android Studio or VS Code installed
- [x] Android device or emulator ready
- [x] Google/Firebase account created

---

## Firebase Setup

### Create Project
- [x] Visit https://console.firebase.google.com/
- [x] Click "Create a project"
- [x] Name: "watchlist-app" (or your choice)
- [x] Disable Google Analytics (optional)
- [x] Click "Create project"
- [x] Wait for project creation

### Add Android App
- [x] Click Android icon in Firebase Console
- [x] Enter package name: `com.example.flutter_watchlist`
- [x] Enter app nickname: "Watchlist App" (optional)
- [x] Click "Register app"
- [x] Download `google-services.json`
- [x] Place file in: `flutter_watchlist/android/app/google-services.json`
- [x] Verify file is in correct location
- [x] Click "Next" → "Continue to console"

### Enable Firestore
- [x] In Firebase Console, click "Firestore Database"
- [x] Click "Create database"
- [x] Select "Start in test mode"
- [x] Choose nearest location
- [x] Click "Enable"
- [x] Wait for database setup

### Configure Firestore Rules
- [x] Go to Firestore → Rules tab
- [x] Replace with test mode rules:
  ```
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /movies/{document=**} {
        allow read, write: if true;
      }
    }
  }
  ```
- [x] Click "Publish"
- [x] Verify rules are published

---

## Local Setup

### Project Files
- [ ] All files extracted to `flutter_watchlist/` folder
- [ ] `lib/main.dart` exists
- [ ] `lib/movie_model.dart` exists
- [ ] `pubspec.yaml` exists
- [ ] `android/app/build.gradle` exists
- [ ] `android/build.gradle` exists

### Critical File Check
- [ ] `android/app/google-services.json` exists (MUST HAVE!)
- [ ] Open file and verify it has your Firebase project info
- [ ] Package name in file matches: `com.example.flutter_watchlist`

### Install Dependencies
Open terminal in `flutter_watchlist/` folder:
- [ ] Run: `flutter pub get`
- [ ] No errors shown
- [ ] Dependencies downloaded successfully

### Connect Device
- [ ] Android device connected via USB OR
- [ ] Android emulator running
- [ ] Run: `flutter devices`
- [ ] Your device appears in list

---

## First Run

### Build & Run
- [ ] Run: `flutter run`
- [ ] Build completes without errors
- [ ] App installs on device/emulator
- [ ] App launches successfully
- [ ] You see "My Watchlist" screen

### Test Firestore Connection
- [ ] Tap + button (bottom right)
- [ ] Fill in movie details
- [ ] Tap "Add Movie"
- [ ] Movie appears in list
- [ ] Go to Firebase Console → Firestore → Data
- [ ] Verify `movies` collection exists
- [ ] Verify your movie document is there

---

## Feature Testing

### CRUD Operations
- [ ] **Create:** Add a new movie successfully
- [ ] **Read:** See movie in the list
- [ ] **Update:** Edit movie title/rating
- [ ] **Delete:** Remove a movie (with confirmation)

### Additional Features
- [ ] Toggle watched status (circle → checkmark)
- [ ] Filter: View "All" movies
- [ ] Filter: View "To Watch" only
- [ ] Filter: View "Watched" only
- [ ] Add movie with image URL
- [ ] Image loads correctly
- [ ] Form validation works (try empty title)

---

## Image URL Testing

### Get Image URL
- [ ] Open Chrome on your phone
- [ ] Search: "Inception poster"
- [ ] Tap Images
- [ ] Long-press an image
- [ ] Tap "Copy image address"
- [ ] URL copied to clipboard

### Test in App
- [ ] Paste URL in "Add Movie" form
- [ ] Add the movie
- [ ] Image displays correctly
- [ ] If not, try different image URL

---

## Troubleshooting (If Needed)

### Build Errors
- [ ] Tried: `flutter clean` then `flutter pub get`
- [ ] Verified `google-services.json` exists
- [ ] Checked package name matches
- [ ] Read TROUBLESHOOTING.md

### Firestore Errors
- [ ] Checked Firestore is enabled
- [ ] Verified rules are in test mode
- [ ] Confirmed internet connection
- [ ] Checked Firebase Console for errors

### Image Errors
- [ ] Using HTTPS URLs (not HTTP)
- [ ] URL ends with .jpg, .png, or .webp
- [ ] Tested URL in browser first
- [ ] Tried different image source

---

## Customization (Optional)

### Change Colors
- [ ] Open `lib/main.dart`
- [ ] Find `ThemeData` section
- [ ] Change `primarySwatch: Colors.deepPurple`
- [ ] Try: blue, green, red, teal, orange, etc.
- [ ] Hot reload (press 'r' in terminal)

### Add More Movies
- [ ] Added at least 3 test movies
- [ ] Tested filter with watched/unwatched
- [ ] Verified ratings display correctly

---

## Production Checklist (When Ready)

### Security
- [ ] Implement Firebase Authentication
- [ ] Update Firestore rules to require auth
- [ ] Remove test mode rules

### Polish
- [ ] Add app icon
- [ ] Add splash screen
- [ ] Test on multiple devices
- [ ] Fix any UI issues

### Release
- [ ] Update version in `pubspec.yaml`
- [ ] Build release APK
- [ ] Test release build
- [ ] Prepare Play Store listing

---

## Quick Reference

**Add Movie:**
+ button → Fill form → Add Movie

**Edit Movie:**
Tap Edit on card → Update form → Update Movie

**Delete Movie:**
Tap Delete → Confirm

**Toggle Watched:**
Tap card or checkmark icon

**Filter:**
Top right menu → Select filter

**Get Image URL:**
Chrome → Search poster → Long-press → Copy image address

---

## Status Summary

**Setup Complete When:**
- [x] All Firebase steps done
- [x] All local setup done
- [x] App runs successfully
- [x] Can add/edit/delete movies
- [x] Firestore sync working

**Ready to Use When:**
- [x] All feature testing complete
- [x] Image URLs working
- [x] No errors in console

---

## Need Help?

1. **Check Documentation:**
   - README.md - Full guide
   - SETUP.md - Quick start
   - TROUBLESHOOTING.md - Common issues
   - APP_OVERVIEW.md - Features & architecture

2. **Common Issues:**
   - 90% of errors = missing google-services.json
   - Check Firebase Console for errors
   - Verify internet connection
   - Run `flutter doctor` to check setup

3. **Still stuck?**
   - Read error message carefully
   - Search error on Google/Stack Overflow
   - Check Flutter/Firebase docs

---

**Once all checkboxes are checked, you're ready to go! 🎉**

Start adding your favorite movies and series to your watchlist!
