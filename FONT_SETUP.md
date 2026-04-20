# FONT SETUP - REQUIRED FOR URDU PDF

## The Problem
Without an Urdu font, PDF shows empty boxes instead of Urdu text.

## Fix - Download Font Files (One Time Only)

### Step 1: Create the fonts folder
Inside your bill_app project, create this folder:
  bill_app/assets/fonts/

### Step 2: Download these 2 font files
Go to: https://fonts.google.com/noto/specimen/Noto+Naskh+Arabic
Click "Download family" 

OR direct links:
- https://github.com/google/fonts/raw/main/ofl/notonaskharabic/NotoNaskhArabic%5Bwght%5D.ttf

For simplicity, download from:
https://noto-website-2.storage.googleapis.com/pkgs/NotoNaskhArabic-hinted.zip

Extract and place:
- NotoNaskhArabic-Regular.ttf  → bill_app/assets/fonts/
- NotoNaskhArabic-Bold.ttf     → bill_app/assets/fonts/

### Step 3: Run
flutter pub get
flutter run

## Alternative - Use any Arabic/Urdu TTF font you have
Rename any Arabic font to:
- NotoNaskhArabic-Regular.ttf
- NotoNaskhArabic-Bold.ttf
and place in assets/fonts/
