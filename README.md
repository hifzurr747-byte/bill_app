# 🧾 Abdul Majeed & Co. — Bill Printing App (Flutter)

## شرکت کی معلومات | Company Details

**عبدالمجید اینڈ کمپنی**  
غلہ منڈی حسن خان والا، تحصیل کلورکوٹ، ضلع بھکر  
پروپرائٹر: عبدالمجید خان

---

## Features | خصوصیات

- ✅ **Bilingual Support** — Switch between Urdu (اردو) and English با ایک بٹن
- ✅ **Bill Creation** — Add customer name, bill number, date, and unlimited items
- ✅ **Live Amount Calculation** — Qty × Rate auto-calculated
- ✅ **PDF Generation** — Professional A5-sized bill PDF
- ✅ **Print** — Direct printing on any connected printer (Windows + Android)
- ✅ **Share** — Share PDF via WhatsApp, email, or any app
- ✅ Works on **Android (Mobile)** and **Windows (Desktop)**

---

## How to Run | کیسے چلائیں

### Prerequisites
- Flutter SDK >= 3.0.0 installed
- For Windows: Visual Studio Build Tools installed
- For Android: Android Studio + emulator or physical device

### Steps

```bash
# 1. Navigate to the project folder
cd bill_app

# 2. Get dependencies
flutter pub get

# 3. Run on Android
flutter run

# 4. Run on Windows
flutter run -d windows

# 5. Build release APK (Android)
flutter build apk --release

# 6. Build Windows EXE
flutter build windows --release
```

---

## Adding Urdu Font (Recommended for better Urdu rendering)

For best Urdu display, add a proper Nastaliq/Naskh font:

1. Download **Noto Naskh Arabic** from Google Fonts
2. Place `.ttf` files in `assets/fonts/`
3. Uncomment the font section in `pubspec.yaml`
4. In `bill_preview_screen.dart`, uncomment the font loading lines

---

## Project Structure

```
lib/
├── main.dart              # App entry point + language toggle
├── bill_model.dart        # Data models (Bill, BillItem, CompanyInfo)
├── bill_form_screen.dart  # Form to create bill
└── bill_preview_screen.dart # Preview + PDF print/share
```

---

## Bill Layout (matches original)

| تعداد | تفصیل | نرخ | رقم |
|-------|--------|-----|-----|
| Qty   | Desc   | Rate | Amount |
|       |        |      | **میزان / Total** |

---

## Contact Numbers in App
- 0301-7951073
- 0317-7951073
- 0345-7951073
- 0453-451373
- حمزہ بلوچ: 0301-4321673
