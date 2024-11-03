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
![sreenshot_1](https://github.com/user-attachments/assets/da3623f1-28da-4f05-abd2-25472d3c2f33)
![sreenshot_2](https://github.com/user-attachments/assets/335c1645-c07d-4a4b-b25e-070380968be7)
![sreenshot_3](https://github.com/user-attachments/assets/390bbee2-0a7a-4fa3-af7e-fce9562ccaeb)
![sreenshot_4](https://github.com/user-attachments/assets/cc17e16e-81e8-4822-8231-26923d9fe8fd)

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
