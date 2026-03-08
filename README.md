
# GateWise – Mobile App

<p align="center">
  <img width="200px" alt="gatewise-app-demo" src="https://github.com/user-attachments/assets/b8cc80f2-81bb-4ac3-9940-b7d48bb48450"/>
</p>


This repository contains the **Flutter mobile application** for the GateWise ecosystem.

The app allows users to authenticate securely, request access to laboratories, and interact with the physical access control system connected to IoT devices.

GateWise is designed as a distributed system composed of multiple modules:

1. **ESP32 Device** → Controls the physical lock and verifies signed commands.  
2. **Mobile App (this repo)** → Allows users to authenticate and request lab access.  
3. **Backend (.NET + Keycloak + RabbitMQ)** → Handles authentication, authorization and command orchestration.  
4. **Admin Dashboard** → Web interface for managing labs, users and permissions.

The mobile application acts as the **user interface layer** of the platform, enabling secure interaction with the backend and the access control devices.

---

# What the app does

- Authenticate users using **OAuth 2.1 Authorization Code Flow with PKCE**
- Integrate with **Keycloak** as the identity provider
- Display available laboratories and user permissions
- Send **signed access requests** to open laboratory doors
- Show real-time feedback after lock confirmation
- Manage authentication tokens securely on the device

---

# Authentication flow

The mobile app follows modern mobile authentication standards.

1. User logs in through **Keycloak**
2. The app performs **Authorization Code Flow with PKCE**
3. Keycloak returns **access and refresh tokens**
4. The mobile app calls the backend API using the access token
5. The backend validates the token and processes access requests

PKCE is required by **OAuth 2.1 for public clients**, ensuring protection against authorization code interception attacks.

---

# Access request flow

When a user requests to open a laboratory door:

1. The mobile app sends an authenticated request to the backend
2. The backend validates permissions and generates a **signed command (RSA)**
3. The command is sent to the ESP32 device via the messaging system
4. The device verifies the signature before executing the action
5. The device sends a signed confirmation to the backend
6. The backend notifies the mobile application so the UI can update the access status

This ensures that **only trusted commands can trigger physical lock actions**.

---

# Tech stack

- **Flutter**
- **Dart**
- **OpenID Connect**
- **OAuth 2.1 + PKCE**
- **Keycloak**
- **REST APIs**
- **Secure token storage**

The backend services use **.NET, RabbitMQ and event-driven architecture**, while the physical access control is handled by **ESP32 devices**.

---

# Project structure

```
gatewise_app/
├─ lib/
│  ├─ core/           # Shared services and utilities
│  ├─ modules/
│  │  ├─ auth/        # Authentication logic
│  │  ├─ home/        # Main dashboard
│  │  ├─ labs/        # Laboratory access features
│  │  └─ settings/    # User settings
│  └─ main.dart
│
├─ assets/
├─ pubspec.yaml
└─ README.md
```

---

# Running the app

1. Install Flutter

https://flutter.dev/docs/get-started/install

2. Install dependencies

```
flutter pub get
```

3. Run the app

```
flutter run
```

Make sure the backend services and authentication server are available.

---

# Demo


You can see a short demo of the application here:

https://github.com/user-attachments/assets/9a4b1a6a-1f72-4fa2-92ea-2458cd4ed8cd


---

# Next steps

- Add biometric authentication support  
- Improve offline token handling  
- Add access history visualization  
- Push notifications for access events  

---

# License

This project is licensed under the MIT License.
