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
![Screenshot 1](screenshots/screenshot_1.webp)
![Screenshot 2](screenshots/screenshot_2.webp)
![Screenshot 3](screenshots/screenshot_3.webp)
![Screenshot 4](screenshots/screenshot_3.webp)

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
flutter run -- 
```
5. Enjoy the app!
