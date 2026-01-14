# roast_my_cart

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
 #  Roast My Cart

**A savage AI-powered financial advisor that judges your spending habits before you regret them.**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Google%20Gemini%20AI-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)

---

##  Project Overview

**Roast My Cart** is not a traditional budget tracker.  
It is a **pre-purchase financial intervention app** designed to reduce impulse buying using **humor, accountability, and AI-driven feedback**.

In an era of frictionless spending—where one-click checkouts and quick-commerce apps make spending effortless—this app intentionally adds *friction*. Before buying something unnecessary, users are forced to confront an AI that questions (and roasts) their choices.

The user uploads:
- A photo of the item they want to buy
- A short justification for the purchase

The app then uses **Google Gemini 1.5 Flash (multimodal)** to analyze both inputs and return a **brutally honest verdict**.

---

##  Problem Statement

- **Impulse buying is widespread:** A significant portion of online purchases are unplanned.
- **Passive tracking fails:** Expense trackers inform users *after* the money is gone.
- **Lack of emotional intervention:** Spending decisions are emotional, not logical.

###  Solution
**Roast My Cart** intervenes *before* the purchase by:
- Analysing the product visually
- Evaluating the justification
- Delivering humor-based financial advice that actually sticks

---

##  Key Features

- **Multimodal AI Analysis**  
  Uses image + text input together to assess the purchase context.

- **Category-Aware Roasting**  
  Roast tone adapts based on the product category (Tech, Fashion, Food, etc.).

- **Dark-Themed Minimal UI**  
  Designed to feel premium, intimidating, and distraction-free.

- **Instant Verdict System**  
  Clear recommendation: **BUY** or **SKIP**, based on necessity vs cost.

---

##  Tech Stack & Architecture

###  Frontend — Flutter (Dart)
- Single codebase for cross-platform deployment
- Clean UI using Material components
- `StatefulWidget` and `setState()` for state management
- `FutureBuilder` for async AI responses

###  AI Engine — Google Gemini 1.5 Flash
- **Model:** `gemini-1.5-flash`
- **Why Gemini Flash?**
  - Supports **multimodal input (image + text)**
  - Low latency suitable for real-time applications
  - High reasoning quality for contextual responses

---

##  How to Run the Project

###  Prerequisites
1. Flutter SDK installed
2. Google Cloud API Key with **Generative Language API** enabled

---

###  Setup Instructions

#### 1. Clone the Repository
```bash
git clone https://github.com/your-username/roast-my-cart.git
cd roast-my-cart
```
#### 2. Install Dependencies
````bash
flutter pub get
````
#### 3. Configure API Key
````bash
static const String apiKey = 'YOUR_API_KEY_HERE';
````
#### 4. Run the App
````bash
flutter run
````

