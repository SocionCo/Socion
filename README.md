# Socion

Socion is a SwiftUI app providing contract management to influencer agencies.

## Installation

Socion is not yet publicly available on the appstore. To run the app on your machine, download [Xcode](https://developer.apple.com/xcode/).

Git clone the repository in terminal.

```bash
git clone https://github.com/SocionCo/Socion.git
```

Then open the .xcodeproj file in xCode and launch the simulator.

## Technologies
Socion currently uses SwiftUI on the front end, and Swift and FireBase on the backend.

## Features to be implemented:
-Reset Password
-Meta / TikTok API integration
-ContractListView remake
-Rate View
-SnapshotListeners don't fire when a member is removed
-Scrollview on login
-Talent Manager
-Snapshot listener on refresh

Bugs:
-Accepting an invite doesn't immediately give access to agency stuff
-Will be glitches if TM sends out multiple invites, need to restrict that 
-Listener bugs with the way contracts update (don't update automatically when new influencer joins and will sometimes double populate)

For the 15th:
-Basic Crashes
-Change Firestore
-Image/Fire storage
-Media Kit View
