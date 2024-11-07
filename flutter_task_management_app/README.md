# Task Management Application

A comprehensive Task Management Application developed in Flutter with SQLite integration, designed for efficient daily task management with features such as task addition, modification, deletion, categorization, custom notifications, and more.

## Table of Contents
- [Objective](#objective)
- [Features](#features)
- [Getting Started](#getting-started)
- [Screenshots](#screenshots)
- [Usage](#usage)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Objective
The goal of this project is to create a fully functional task management app that assists users in managing daily tasks effectively. This project includes advanced functionalities such as task repetition, progress tracking, and data export options.

## Features
1. **User Interface**
   - Views:
     - **Today Task**: Displays tasks due on the current day.
     - **Completed Task**: Shows tasks that have been completed.
     - **Repeated Task**: Lists tasks that recur on specified days or intervals.

2. **Task Management**
   - Add, edit, and delete tasks with details like title, description, due date, and optional repeat settings.
   - Mark tasks as completed, automatically moving them to the 'Completed Task' category.

3. **Advanced Features**
   - **Customization Options**: Theme customization (light and dark mode) and notification sound selection.
   - **Progress Tracking**: Track progress with subtasks and view a completion progress bar or percentage.
   - **Export Options**: Export tasks to CSV, PDF, and email formats.
   - **Repeat Tasks**: Set tasks to repeat daily or on specific days, with automatic reset.

4. **Notifications**
   - Local notifications for reminders on upcoming tasks based on due dates and times.

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [SQLite Plugin](https://pub.dev/packages/sqflite)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/task_management_app.git
