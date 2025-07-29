# API Usage Examples

This document provides examples of how to use the API services in the `flutter_simple_services` package.

## Basic Setup

```dart
import 'package:flutter_simple_services/flutter_simple_services.dart';

// Initialize the service manager
final serviceManager = ServiceManager();

// Enable logging for debugging
serviceManager.enableLogging(true);

// Set custom base URL if needed
serviceManager.setBaseUrl('https://api.example.com');

// Set authentication token
serviceManager.setAuthToken('your_auth_token_here');
```

## User Management

### Get All Users
```dart
try {
  final users = await serviceManager.getUsers();
  print('Found ${users.length} users');
  for (final user in users) {
    print('User: ${user.name} (${user.email})');
  }
} catch (e) {
  print('Error fetching users: $e');
}
```

### Get Single User
```dart
try {
  final user = await serviceManager.getUser(1);
  print('User details: ${user.name}');
  print('Email: ${user.email}');
  print('Phone: ${user.phone ?? 'N/A'}');
  print('Website: ${user.website ?? 'N/A'}');
} catch (e) {
  print('Error fetching user: $e');
}
```

### Create New User
```dart
final newUser = User(
  id: 0, // Will be assigned by server
  name: 'John Doe',
  email: 'john.doe@example.com',
  phone: '+1-234-567-8900',
  website: 'johndoe.com',
);

try {
  final createdUser = await serviceManager.createUser(newUser);
  print('Created user with ID: ${createdUser.id}');
} catch (e) {
  print('Error creating user: $e');
}
```

### Update User
```dart
final updatedUser = User(
  id: 1,
  name: 'Jane Doe',
  email: 'jane.doe@example.com',
  phone: '+1-234-567-8901',
  website: 'janedoe.com',
);

try {
  final result = await serviceManager.updateUser(1, updatedUser);
  print('Updated user: ${result.name}');
} catch (e) {
  print('Error updating user: $e');
}
```

### Delete User
```dart
try {
  await serviceManager.deleteUser(1);
  print('User deleted successfully');
} catch (e) {
  print('Error deleting user: $e');
}
```

## Post Management

### Get All Posts
```dart
try {
  final posts = await serviceManager.getPosts();
  print('Found ${posts.length} posts');
  for (final post in posts.take(5)) { // Show first 5
    print('Post: ${post.title}');
  }
} catch (e) {
  print('Error fetching posts: $e');
}
```

### Get Posts by User
```dart
try {
  final userPosts = await serviceManager.getPostsByUser(1);
  print('User has ${userPosts.length} posts');
  for (final post in userPosts) {
    print('- ${post.title}');
  }
} catch (e) {
  print('Error fetching user posts: $e');
}
```

### Create New Post
```dart
final newPost = Post(
  userId: 1,
  id: 0, // Will be assigned by server
  title: 'My New Post',
  body: 'This is the content of my new post. It can be quite long and contain multiple paragraphs.',
);

try {
  final createdPost = await serviceManager.createPost(newPost);
  print('Created post with ID: ${createdPost.id}');
} catch (e) {
  print('Error creating post: $e');
}
```

## Search Functionality

### Search Posts by Title
```dart
try {
  final searchResults = await serviceManager.searchPosts('sunt');
  print('Found ${searchResults.length} posts matching "sunt"');
  for (final post in searchResults) {
    print('- ${post.title}');
  }
} catch (e) {
  print('Error searching posts: $e');
}
```

### Search Users by Name
```dart
try {
  final searchResults = await serviceManager.searchUsers('Leanne');
  print('Found ${searchResults.length} users matching "Leanne"');
  for (final user in searchResults) {
    print('- ${user.name} (${user.email})');
  }
} catch (e) {
  print('Error searching users: $e');
}
```

## Error Handling

The service manager automatically handles common HTTP errors and provides meaningful error messages:

```dart
try {
  final user = await serviceManager.getUser(999); // Non-existent user
} catch (e) {
  print('Error: $e'); // Will print: "Resource not found."
}

try {
  // Simulate network error
  serviceManager.setBaseUrl('https://invalid-url-that-does-not-exist.com');
  final users = await serviceManager.getUsers();
} catch (e) {
  print('Error: $e'); // Will print: "No internet connection." or similar
}
```

## Advanced Configuration

### Custom Headers
```dart
final dioClient = serviceManager.dioClient;

// Add custom headers
dioClient.addHeader('X-API-Version', '1.0');
dioClient.addHeader('X-Client-Type', 'mobile');

// Remove headers when no longer needed
dioClient.removeHeader('X-API-Version');
```

### Logging Control
```dart
// Enable detailed logging
serviceManager.enableLogging(true);

// Disable logging
serviceManager.enableLogging(false);
```

### Direct Dio Access
If you need more control, you can access the underlying Dio client:

```dart
final dio = serviceManager.dioClient.dio;

// Add interceptors
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    print('Custom request interceptor');
    handler.next(options);
  },
));

// Make custom requests
final response = await dio.get('/custom-endpoint');
```

## Calculator Examples

The package also includes a simple calculator service:

```dart
final calculator = Calculator();

print('Add one: ${calculator.addOne(5)}'); // 6
print('Add: ${calculator.add(3, 4)}'); // 7
print('Multiply: ${calculator.multiply(3, 4)}'); // 12
print('Divide: ${calculator.divide(10, 2)}'); // 5.0

try {
  calculator.divide(5, 0); // Throws ArgumentError
} catch (e) {
  print('Error: $e'); // Cannot divide by zero
}
```
