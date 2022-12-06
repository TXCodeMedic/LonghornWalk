<!-----

Yay, no errors, warnings, or alerts!

Conversion time: 0.746 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β33
* Mon Dec 05 2022 19:28:41 GMT-0800 (PST)
* Source doc: README file: Longhorn Walk
* Tables are currently converted to HTML tables.
----->


**README file: **

**Name of project:** LonghornWalk

**Team members:** Katsiaryna Aliashkevich, Matthew Galvez, Rayna Sevilla, Yousuf Din

**Dependencies:** Xcode 13.0, Swift 5 

**Special Instructions:** 

• Use an iPhone 14 Pro Simulator in Portrait Mode

• Install the Firebase package dependency 

• If you want to test the app without going to each location on campus uncomment the “return true” on “LocationViewController” (Line 142)

**Required feature checklist **



1. Login/register path with Firebase. 
2. “Settings” screen. The three behaviors we implemented are: (fill in) \
 <span style="text-decoration:underline;">Change Fonts, Night Mode/ Day Mode, and Mute Sound  </span>
3. Non-default fonts and colors used 

Two major elements used: 



1. Core Data 
2. User Profile path using camera and photo library 
3. Multithreading 
4. SwiftUI 

Minor Elements used 



1. Two additional view types such as sliders, segmented controllers, etc. The two we implemented are: (fill in) ___<span style="text-decoration:underline;">Segmented Control, Switch, TextView, and Bar Buttons</span>

One of the following: 



1. Table View 
2. Collection View 
3. Tab VC 
4. Page VC 

Two of the following: 



1. Alerts 
2. Popovers 
3. Stack Views 
4. Scroll Views 
5. Haptics 
6. User Defaults 

At least one of the following per team member: 



1. Local notifications 
2. Core Graphics 
3. Gesture Recognition 
4. Animation 
5. Calendar 
6. Core Motion 
7. Core Location / MapKit 
8. Core Audio 
9. Others (such as QR code, Koloda, etc.) with approval from the instructor – list them 

**Work Distribution Table**


<table>
  <tr>
   <td><strong>Required Feature</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Who / Percentage worked on</strong>
   </td>
  </tr>
  <tr>
   <td>Launch Screen with Animation & Sound
   </td>
   <td>Animated logo appears on launch along with sound
   </td>
   <td>Yousuf 100%
   </td>
  </tr>
  <tr>
   <td>Login/Register Path (Firebase)
   </td>
   <td>Check the entered email and password to either log the user into their existing profile, or create a new profile with those credentials.
   </td>
   <td>Katrina 60%
<p>
Matthew 20%
<p>
Rayna 20%
   </td>
  </tr>
  <tr>
   <td>Homescreen (check date)
   </td>
   <td>- The Homescreen acts as the hub of the app where the user can see their name, score, profile picture, and status label that is derived from their score. 
<p>
- On launch the app will check for the day and compare it with the user’s last update. If there is a difference the “recently visited” locations will be refreshed and the user will be able to go to the locations again for points.
<p>
- When the user taps on a visited location, a detailVC opens up that displays the location image and name. 
   </td>
   <td>Matthew 25%
<p>
Katrina 25%
<p>
Rayna 25%
<p>
Yousuf 25%
   </td>
  </tr>
  <tr>
   <td>CoreData
   </td>
   <td>Passing information from Location VC to HomeScreen VC through prepare for segue to store in core data
   </td>
   <td>Rayna 100%
   </td>
  </tr>
  <tr>
   <td>TableView on Homescreen
   </td>
   <td>Table view delegates and datasource retrieved core data
   </td>
   <td>Rayna 50%
<p>
Yousuf 50%
   </td>
  </tr>
  <tr>
   <td>Logout Function 
   </td>
   <td>Logs the user out of their profile and return to the LoginVC.
   </td>
   <td>Katrina 100%
   </td>
  </tr>
  <tr>
   <td>LocationVC
<p>
(Check Locations)
   </td>
   <td>- The LocationVC hosts 10 locations at UT Austin campus where users can visit and acquire points. 
<p>
- The “LocationVC” uses CoreLocation to determine the location of the user to determine if they are at the selected location. If the user is at the location, 25 points will be added to their score.
<p>
- The location also has a “Directions” button that will segue into a mapview where the user will get directions to the selected building.
   </td>
   <td>Matthew 70%
<p>
Yousuf 20%
<p>
Rayna 10%
   </td>
  </tr>
  <tr>
   <td>MapView and Directions
   </td>
   <td>MapView that provides directions from current location to selected location. Route line appears and textView for walking directions appears. 
   </td>
   <td>Yousuf 100%
   </td>
  </tr>
  <tr>
   <td>Gestures
   </td>
   <td> - Swipe left and right on the “LocationVC” to select a different location.
<p>
 - Tap to dismiss the keyboard.
   </td>
   <td>Matthew 50%
<p>
Yousuf 50%
   </td>
  </tr>
  <tr>
   <td>User() Class & Firebase Firestore
   </td>
   <td>Create a class to store all the fields of the current user in as parameters. 
<p>
This makes it easier to adjust the data inside of Firestore at the same time as the user changes it in the app. When that user logs back in with their credentials, all of their previous data is loaded back into the app.
   </td>
   <td>Katrina 80%
<p>
Matthew 20%
   </td>
  </tr>
  <tr>
   <td>User Profile VC
   </td>
   <td>View Controller displays all of the user’s information including their score, display name, email, profile picture, and status level. ViewController gets updated every frame to reflect the changes the user makes inside the app
   </td>
   <td>Katrina 100%
   </td>
  </tr>
  <tr>
   <td>Edit User Profile VC
   </td>
   <td>Lets the user edit their profile by changing their display name
   </td>
   <td>Katrina 100%
   </td>
  </tr>
  <tr>
   <td>Delete Profile Function
   </td>
   <td>Button that deletes the user’s credentials from Firebase as well as deleting all of the data connected to that user from Firestore.
   </td>
   <td>Katrina 100%
   </td>
  </tr>
  <tr>
   <td>Profile Picture Upload/Download (Firebase Storage /Firestore)
   </td>
   <td> - The user can upload a profile picture from their photo album, or their camera. The picture then gets saved onto our Firebase Storage and the filepath gets saved in their Firebase Firestore in order to get downloaded and presented.
   </td>
   <td>Matthew 50%
<p>
Katrina 50%
   </td>
  </tr>
  <tr>
   <td>Settings
   </td>
   <td>iPhone system settings clone with switches for dark/light mode and audio on/off. Action sheet for user to select font. Course website button opens safari to bulko’s website. 
   </td>
   <td>Yousuf 100%
   </td>
  </tr>
  <tr>
   <td>User Defaults
   </td>
   <td>Settings preferences (dark/light mode, sound, and font type) stored in user defaults and persists. 
   </td>
   <td>Yousuf 100%
   </td>
  </tr>
  <tr>
   <td>Core Audio
   </td>
   <td>Audio plays upon launching the app and fades as the login/registration VC appears. 
   </td>
   <td>Yousuf 100%
   </td>
  </tr>
  <tr>
   <td>Alerts
   </td>
   <td>-Alerts for when incorrect credentials are entered for login/registration
<p>
- Alerts for successful location visit and invalid location visit
<p>
- Alert for CoreData refresh due to a new day on “HomeScreenVC”
<p>
-Settings alerts for terms of service, privacy policy, and learn more. 
<p>
- Alerts on EditUserProfile to pick between camera and photo gallery for profile pic
<p>
-Alert on EditUserProfile to let the user know their changes were saved when they press save button
   </td>
   <td>Matthew 25% 
<p>
Katrina 25%
<p>
Rayna 25%
<p>
Yousuf 25%
   </td>
  </tr>
  <tr>
   <td>Segmented Control
   </td>
   <td> - Segmented control in the “LoginVC” allows for users to switch between login and sign-up mode.
   </td>
   <td>Matthew 100%
   </td>
  </tr>
  <tr>
   <td>Navigation/Bar Buttons
   </td>
   <td>Embed navigation controller and show segues. Created bar button items with images.
   </td>
   <td>Rayna 100%
   </td>
  </tr>
  <tr>
   <td>UI Design
   </td>
   <td>Initial VC layouts and overall design of app functionality 
   </td>
   <td>Yousuf 70%
<p>
Rayna 30%
   </td>
  </tr>
</table>

