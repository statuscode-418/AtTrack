# AtTrackt
# Status Code 1
# Team Name : status_code-418
# Team Members : Nabajit Bhadury, Kaushik Chowdhury, Anjishnu Ganguly, Rohan Mitra, Aratrik Bandyopadhyay.
<h1 align="center"> A hassle free Event Entry Tracker </h1>
<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#🤩 About The Project">About The Project</a></li>
    <li><a href="#👨‍💻 Tech Stacks used ">Tech Stacks used</a></li>
    <li><a href="#📌 Usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#💻 installation">Installation</a></li>
    <li><a href="#contributors">Contributors</a></li>
  </ol>
</details>


<h1 id="about-the-project">🤩 About The Project :</h1>


# 💭 Inspiration :
- Being college students, we are enrolled in a lot of communities. We do a lot of community meetings and events as well. One problem that comes up frequently is attendance. We need to take the attendance of attendees for college administrative purposes, proof of impersonation and it also helps to keep track of activeness of the members. 
![image](https://utfs.io/f/ce7efacd-185f-4874-a04a-3607e09ff709-fwpcco.jpeg)

Some existing solutions are:

-  <H3>Physical Ledger</H3> 
&nbsp;&nbsp; The physical ledger book is simple, you just take a ledger book and makes the attendee fill in their details one by one.

Pros:
1. Easy to set up initially
2. No previous knowledge of attendees needed.

Cons: 
1. Takes too much time to resister each attendee one by one.
2. Much more hassle to entry that data in Excel sheet.
 


-  <H3>Custom attendance systems for large meetings</H3>
&nbsp;&nbsp; Some large event uses QR attendance system to keep track of attendance.

Pros:
1. Fast attendance
2. Digital data so easy to manipulate

Cons:
1. You must have a attendee list beforehand, mostly taken through Google forms
2. A big hassle for small community meetings

- To solve this problem , we came up with a solution using *Cross Platform Framework Flutter*. 
Getting inspiration from these two systems, and analysing it's pros and cons, we made our app AtTrackt.



# 💡 What problem does the project solve?
- The project aims to solve the problem of *Attendance Tracking* in all community meetings.
- Creating a meeting is as easy as pressing a button and does not need an attendee list beforehand.
- By scanning the generated QR registration of candidates becomes easy and less time consuming.
- The export feature uploads all details in Excel sheet thus saving us from the manual labour of data entry.


<h1 id="usage">📌 Usage :</h1>

### Register phase:
1. Users will register using email and password.
2. Data of students like name, roll, sem, phone, GitHub profile (optional), LinkedIn profile (optional)
3. Once logged in, you can create a profile and you can either join or create a meeting.

### Create meeting:
1. Once logged in, go to create meetings tab
2. There you will see your past meetings if you have any
3. Tap on create meeting
4. You will be navigated to a screen where you'll see a QR code, using which attendee will mark their attendance.
5. Below the QR code you'll get the list of attendees who scanned the QR
6. Once all the attendance is taken, press the export button to export the details of attendees in Excel sheet.
7. You can also track the location in a fixed radius, so that any attendee who will scan the QR and not attend the meeting doesn't get the ECA.

![image](https://utfs.io/f/bd217dca-d743-4958-b92c-8126f4efdf37-fw5js6.jpeg)

### Join a meeting:
1. Click the scan QR button
2. Scan the QR code of a meeting
3. Your attendance is recorded on that meeting

   ![image](https://utfs.io/f/cc99205a-a3e5-42c4-a85f-476490406724-fwpcdj.jpeg)

# 💀 Challenges we ran into:
  - Creating the best UI which is logical as well as simple and easy to use was a challenge
  - To convert the design file into responsive flutter code was a big challenge
  - Managing auth state was a big issue that we solved using block
  - Figuring out the best database model to store the user data was a big challenge
  - Managing a team of developer to push their code in a single repo and work together was a big challenge in itself

![image](https://utfs.io/f/32a73e56-8aa4-4f1d-9bf6-e5552f1dd206-7w30ii.32.44.jpeg)
![image](https://utfs.io/f/6785d396-046a-4099-b2b1-c00d64feaec2-7w30ii.32.45.jpeg)
 
# 🔮 What's Next For Our Project:
- Making the attendace tracking system in a more organised way by enabling the two QR based Attendance Tracker during entry and exit
- Identity Validation of the attendee who is joining the meeting by maintaining a proper database
- Large Screen Optimization and minor bug fixes
  

# <h1 id="tech-stacks-used">👨‍💻 Tech Stacks used :</h1>
- <img src ="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" style="margin-top: 40px" height=30px width=30px > *Dart* : For writing the codebase of the app.
- <img src = "https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" style="margin-top: 40px" height=30px width=30px >*Flutter* :  It gave us a beautiful default setup, and the flexibility to customise as per our need. It also enabled us to ship our app in Android, iOS, and potentially on web from a single codebase.
- <img src = "https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" style="margin-top: 40px" height=30px width=30px >*Firebase Auth* : To make the backend, we used One of the Google cloud services product, Firebase. It enabled us to easily and securely handle user authentication using firebase auth.
- <img src = "https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" style="margin-top: 40px" height=30px width=30px >*Cloud Firestore* : Managing user data using firestore.
- <img src = "https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" style="margin-top: 40px" height=30px width=30px >*Firebase Storage* : For storing profile pics using storage also due to is awesome support for flutter enabled us to easily use it in our project.


# Special Quirks :
- Supports Material U dynamic coloring on android 12+
- Random Profile Avatar on registering based on name

# Tracks Targeted :
- Open Innovation
- Special emphasis has been given over UI and UX to take the user experience to a another level
- Best Freshers Track, since this is our first offline hackathon.


# Installation :

To use this app:
- Download the apk file from <a href="https://github.com/statuscode-418/AtTrackt/build/app/outputs/flutter-apk/app-release.apk">here</a>
- Install the apk
- open the app and Enjoy 😉!!


# Contributing

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "improvement".
Don't forget to star this project!! 

1. Fork the Project
2. Create your Feature Branch (git checkout -b feature/Feature1)
3. Commit your Changes (git commit -m 'Add Feature 1')
4. Push to the Branch (git push origin feature/Feature1)
5. Open a Pull Request

# Contributors

<h3 align="center">Made with ❤️ by Status_code-418!</h3>
<div align="center">
</div>
 <p align ="right"><a href="#top">🔼 Back to top</a></p>
 </div>

