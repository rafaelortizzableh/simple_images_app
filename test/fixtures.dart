import 'package:simple_images_app/features/features.dart';

const samplePhotoModel = PhotoModel(
  smallPhotoUrl:
      'https://images.unsplash.com/photo-1495573925654-ebcb91667e78?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzc1NXwwfDF8YWxsfDJ8fHx8fHwyfHwxNjg3OTY0NTIxfA&ixlib=rb-4.0.3&q=80&w=400',
  regularPhotoUrl:
      'https://images.unsplash.com/photo-1495573925654-ebcb91667e78?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzc1NXwwfDF8YWxsfDJ8fHx8fHwyfHwxNjg3OTY0NTIxfA&ixlib=rb-4.0.3&q=80&w=1080',
  largePhotoUrl:
      'https://images.unsplash.com/photo-1495573925654-ebcb91667e78?crop=entropy&cs=srgb&fm=jpg&ixid=M3wzNzc1NXwwfDF8YWxsfDJ8fHx8fHwyfHwxNjg3OTY0NTIxfA&ixlib=rb-4.0.3&q=85',
  photoAuthor: PhotoAuthor(
    username: 'sixstreetunder',
    name: 'Craig  Whitehead',
    thumbnailProfilePicUrl:
        'https://images.unsplash.com/profile-1494018746819-d1b62af3dc31?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32',
    profilePicUrl:
        'https://images.unsplash.com/profile-1494018746819-d1b62af3dc31?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64',
    bio: '',
  ),
  title: 'GcBuJkuiCpU',
  likes: 712,
  id: 'GcBuJkuiCpU',
);

const emptySamplePhotoModel = PhotoModel(
  smallPhotoUrl: '',
  regularPhotoUrl: '',
  largePhotoUrl: '',
  photoAuthor: PhotoAuthor(
    username: '',
    name: '',
    thumbnailProfilePicUrl: '',
    profilePicUrl: '',
    bio: '',
  ),
  title: '',
  likes: 0,
  id: '',
);

const emptySamplePhotoMap = {
  "id": "",
  "alt_description": "",
  "urls": {
    "raw": "",
    "full": "",
    "regular": "",
    "small": "",
    "thumb": "",
    "small_s3": ""
  },
  "likes": 0,
  "user": {
    "id": "",
    "username": "",
    "name": "",
    "bio": "",
    "profile_image": {"small": "", "medium": "", "large": ""},
  }
};
