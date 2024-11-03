# Simple Images App

This is a simple Flutter app that displays images from the internet. The app uses the `dio` package to fetch images from the Unsplash API.

The app uses `flutter_riverpod` for state management and dependency injection. It uses `shared_preferences` for local storage and `cached_network_image` to cache images.

## Features
- Display images from the internet
- Search for images
- Infinite scrolling
- Mark images as favorite
- View search history
- View details of an image
- Change theme mode (light/dark)
- Change preferred primary color

## Screenshots
![screenshot_1](https://github.com/user-attachments/assets/da3623f1-28da-4f05-abd2-25472d3c2f33)
![screenshot_2](https://github.com/user-attachments/assets/212a65bc-d99a-45de-a3c1-6e12361eb79f)
![screenshot_3](https://github.com/user-attachments/assets/390bbee2-0a7a-4fa3-af7e-fce9562ccaeb)
![screenshot_4](https://github.com/user-attachments/assets/dc0e69b4-be6d-465d-998d-3b1e11f8d61f)



## Getting Started
1. Clone the repository
```bash
git clone https://github.com/rafaelortizzableh/simple_images_app.git
```
2. Navigate to the project directory
```bash
cd simple_images_app
```
3. Install dependencies
```bash
flutter pub get
```
4. Run the app on a connected device or emulator. You need an API key from Unsplash to fetch images. It's set on `--dart-define=UNSPLASH_API=[YOUR_KEY]` when running the app. Optionally you can set the author name as an environment variable with `--dart-define=AUTHOR_NAME=Rafa Ortiz`. The original author name is Rafa Ortiz.
```bash
flutter run --dart-define=UNSPLASH_API=[YOUR_KEY]--dart-define=AUTHOR_NAME="Rafa Ortiz"
```
5. Enjoy the app!
