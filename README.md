# ThreatWise - Cybersecurity Learning Platform

A gamified, interactive Flutter application designed for the **Premier's Coding Challenge (Queensland)**. Our mission is to teach teenagers and everyday users how to stay safe online through a "Duolingo-style" bite-sized learning experience.

---

## Project Overview

The internet can be a dangerous place, but learning about cybersecurity shouldn't be boring. Our app breaks down complex security concepts into fun, digestible modules. From checking password strengths to spotting live phishing attempts, users gain hands-on digital literacy skills to protect themselves online.

### Challenge Alignment & Problem Statement
* **The Problem:** Traditional cybersecurity advice is often delivered via long, text-heavy articles that younger audiences find disengaging, leading to poor online safety habits.
* **Our Solution:** We gamified the learning process. By turning security concepts into interactive simulators and mini-games, we increase user retention and build practical, real-world reflexes.
* **Target Audience:** Developed primarily for Queensland school students navigating an increasingly digital world.

---

### Key Features

Our dashboard serves as the central hub, granting quick access to our core interactive security modules:

* **AI Chatbot:** Learn directly about emerging cyber threats in an interactive Q&A format.
* **Attack Simulator:** A realistic email interface where users can safely practice spotting phishing and social engineering tactics. 
* **Password Checker:** Real-time feedback on user passwords, teaching them how to build uncrackable credentials.
* **Mascot:** Our own mascot just like duolingo help users feel more engaged and creates a trademark for the app. 
* **Progress & Analytics Tracker:** A visual progress system ensuring users stay motivated as they continue their learning journey.

---

## How It Works (Technical Implementation)

* **Phishing Simulation:** The email simulator dynamically generates mock phishing scenarios (e.g., fake banking alerts, urgent delivery scams) and tests whether the user can correctly identify red flags like mismatched URLs or urgent language.
* **Password Strength Algorithm:** The password checker evaluates input text in real-time, checking for length, uppercase letters, numbers, and special characters to teach users the anatomy of a strong credential.
* **AI chatbot:** The chatbot works using Gemini API and its prompted to be only for cybersecurity related stuff, 


### Tech Stack & Architecture

| Component | Technology | Description |
| :--- | :--- | :--- |
| **Frontend Framework** | Flutter & Dart | Cross-platform UI development |
| **Graphics design** | Adobe Illustrator | A digital design software to make the mascots and some icons |
| **Animations** | Rive | Digital software to animate our mascot |

```text
lib/
├── core/
│   ├── constants.dart 
│   └── theme.dart 
├── models/
│   ├── email_scenario.dart 
│   ├── enums.dart  
├── data/
│   ├── email_components.dart 
│   ├── mock_scenarios.dart 
├── features/
│   ├── chatbot/
│   │   ├── chatbot_logic.dart
│   │   └── chatbot_page.dart
│   ├── dashboard/
│   │   ├── dashboard_widgets.dart
│   │   └── dashboard_page.dart
│   ├── incident_report/
│   │   └── report_page.dart
│   ├── minigames/
│   │   └── quiz_page.dart
│   ├── password_system/
│   │   └── password_page.dart
│   └── simulator/
│   │   ├── simulator_logic.dart
│       └── simulator_page.dart
└── main.dart 
```
---

## Challenges Faced & Learnings
* 
    **The Challenge**: We initially struggled with handling responsive layout because the buttons in the dashboard page would just become massive in big screens. 

    **The Solution**: We researched other ways to make responsive layouts and we found that we could use `GridView.builder` to make them responsive and follow a better path. And now its probably one of the most used methods of our page.  
* 
    **The Challenge**: We struggled with adding an image to the app because we were new to this. And because we wanted to make it have a shadow but it kept showing a box instead of the siluete. 

    **The Solution**: We reserached how we could make the shadow a silluete instead of the box behind it. We found you could use a function to make the image blurred behind the actual image (with an offset) and it now works. 

* 
    **The Challenge**: We struggled making the grading system and the simulater with the multiple selection and with the use of lists since its the first time using them and they are a little different from other languages. 

    **The Solution**: We just pushed through google-ing any problem we had until the Simulator was as good as we wanted.


* 
    **The Challenge**: We struggled at the end of the challenge whne it was about to end because we didn't have any courses to present.

    **The Solution**: But we asked lots of our friends to help us build courses for the app, the courses could be about any cybersecurity concept they wanted so it was a nice activity and it helped them learn too. 

---

## Feature description and facts

### Email and Phishing Scenario Generator

Our phishing simulator uses a **component-based scenario generator** rather than relying on hardcoded emails. Each email is dynamically assembled from four independent components:

* **Greeting**
* **Issue**
* **Call to Action (CTA)**
* **Signature**

Each of these components contains **30–50 unique variations**, separated into **legitimate** and **phishing** content. Every variation is also categorized into one of four difficulty levels:

* Easy
* Medium
* Hard
* Expert

This modular approach allows the simulator to generate a huge number of unique email combinations.

| Difficulty | Phishing Scenarios | Legitimate Scenarios | Total Scenarios |
| ---------- | -----------------: | -------------------: | --------------: |
| Easy       |             ~6,300 |               ~5,400 |         ~11,700 |
| Medium     |             ~6,300 |               ~5,400 |         ~11,700 |
| Hard       |             ~5,400 |               ~5,400 |         ~10,800 |
| Expert     |             ~5,400 |               ~5,400 |         ~10,800 |

> *Numbers are approximate and will continue to grow as more components are added.*

Overall, the simulator can generate **approximately 45,000 unique email scenarios**, with a different combination being created each time a user plays. This provides a highly varied experience while making it difficult for players to memorize answers, encouraging them to identify phishing attempts based on the email's content rather than repetition.

### Course Engine

The course engine works by reading .md files that have titles like `### course` or `### quiz` and then the algorythm divides it into course content and questions. 

The course is displayed by using the MarkDown viewer library in flutter making it really easy to display this. 

The question structure in markdown is: 
```md
### Question {num}
{Question Title}
**Difficulty:** {easy, medium, hard, or expert}
**Points:** {points}
- [] Ans 1
- [] Ans 2
- [x] Correct ans 
- [] Ans 4
```
As you can see in the example above the correct ans is recognized by having the cross mark in it. 
and this is divided intro variables in list/dictionary and then you access them and show the Question UI and animations. 

### Animations

The animations made the app completly change its interactivity and look. 
The main animations include the **Confetti**, and the **Sliding animation** on the email simulator. 
The sliding animation had to be coded by scartch but it only took around 2-3 hours to finish and made a really good image. 

The confetti was a lot easier because of the confetti library and it just required some testing but it was done in around 15 minutes. And it took like 5 lines of code and then it generated an amazing feeling and looks. 

## Future Roadmap
If we continue developing this platform, our next steps include:

* **Cyber Trivia Battles**: A local multiplayer mode where students can challenge each other to quick safety quizzes.

* **Live Threat Feed**: A simulated news broadcast pulling in real-world data breaches to teach users about current scams circulating in Australia.

* **Achievement Badges**: Unlockable digital badges as users complete modules to further increase gamification.

---

## Setup & Installation
To run this project locally, make sure you have the Flutter SDK installed on your system.
1. Clone the repository:
    ```Bash
    git clone [https://github.com/benvelzul/Threat-Wise-Premiers-Coding-Challenge.git](https://github.com/benvelzul/Threat-Wise-Premiers-Coding-Challenge.git)
    cd Threat-Wise-Premiers-Coding-Challenge
    ```

2. Fetch dependencies:
    ```Bash
    flutter pub get
    ```
3. Run the app:

    ```Bash
    flutter run
    ```

But if you just want to test it out here is the link: https://benvelzul.github.io/Threat-Wise-Premiers-Coding-Challenge/ 

---

## Team & Acknowledgments
Developed by:

**Benjamin Velez Zuluaga**

**Zander Setiawan**

Submitted for the Premier's Coding Challenge (QLD).

### Tester Credits

* Sebastyen Nagy 
* Tracey Iki
* Belinda Bretherton 
* Matthew Sutherland
* Rosario Velez Zuluaga
* Tatiana Zuluaga Garcia
* Thiago Servidoni Dominguez
* Alexander Sabariz

### Extra Special Credits 

* Matthew Sutherland - Writer of cybersecurity courses
* Tracey Iki - Coordinator of co-curricular activites

## AI usage

This project used AI to research and understand concepts of cyber security, algorithims, and Flutter (and Dart). And some texts like the README was polished by AI to correct grammar (as you can see in this paragraph no AI polished it) and sound more professional. 