# Study TO DO

> A simple Flutter study planner app to track your learning tasks, set due dates, and keep momentum.

---

## 🧠 What is Study TO DO?

Study TO DO is a lightweight Flutter app that helps you organize study sessions, manage tasks, and mark work as complete. It is built with a clean UI, local persistence using SharedPreferences, and is designed to be a solid foundation for a student-friendly study planner.

This project is ideal for:
- Students who want to track study tasks and deadlines
- Learners building a Flutter project for coursework or portfolio
- Anyone who wants to expand the app with gamification (streaks, XP, badges)

---

## ✨ Key Features

- ✅ Add / edit / delete study tasks
- ✅ Set due dates and see overdue tasks
- ✅ Mark tasks as completed (with strikethrough UI)
- ✅ Data saved locally using SharedPreferences (no backend)
- ✅ Simple, clean UI designed for fast task entry

---

## 🚀 How to Run (Local)

### 1) Clone the repo

```bash
git clone https://github.com/darshil2711/Study-TODO.git
cd Study-TODO
```

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Run on your target

- Android emulator / device:
  ```bash
  flutter run
  ```

- Web (Chrome):
  ```bash
  flutter run -d chrome
  ```

> If you're running on Windows and see a Visual Studio toolchain error, install the "Desktop development with C++" workload using the Visual Studio Installer.

---

## 🏗️ Project Structure

- `lib/main.dart` — app entry point
- `lib/screens/` — UI screens (home list, add/edit task)
- `lib/models/` — data model (`StudyTask`)
- `lib/services/` — persistence layer (SharedPreferences repository)

---

## 📦 What you can build next (ideas)

- ✅ **Streak counter**: reward daily study consistency
- ✅ **XP / Level system**: make task completion feel rewarding
- ✅ **Notifications / reminders**: nudge users to study
- ✅ **Task categories+filters**: group tasks by subject or priority

---

## 📝 Assignment Support

This repo can be used as the base for your sprint planning assignment. You can include:
- Sprint backlog + task board screenshots (Trello / GitHub Projects)
- Daily progress logs (markdown or Google Docs)
- Sprint review + retrospective notes

---

## 📄 License

This project is open for learning and experimentation. Feel free to adapt it for your coursework.
