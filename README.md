# To-Do List App Explanation


https://github.com/user-attachments/assets/a908da55-ff5c-4a40-8c2c-3e24141695ba



The build APK for the app is 👇
https://drive.google.com/file/d/1F_rALJedO9hjZAHNOM8RsrwNLnjCNguZ/view?usp=drive_link


This Flutter app is a to-do list manager that allows users to create, edit, delete, and sort tasks, with data persistence using Hive and a dynamic UI supporting light and dark themes. Below is an overview of its functionality and implementation.

## Implementation
The app initially featured a simple to-do list with the following components:
- **UI Components**:
    - `Homepage`: Displays a list of tasks using `ListView.builder` and a `FloatingActionButton` to add tasks.
    - `TodoTile`: Represents each task with a checkbox for completion, a slidable delete action (using `flutter_slidable`), and later an edit action.
    - `DialogBox`: A dialog for adding/editing tasks with a text field and save/cancel buttons.
    - `MyButton`: A reusable button for dialog actions.
- **Data Management**:
    - `TodoDB`: Manages the task list (`List<List<Object?>>`) stored in Hive, with methods to create initial data, load, and update the database.
    - Tasks were stored as `[taskName, isCompleted]` and later extended to include `[taskName, isCompleted, creationDate, dueDate]`.
- **Features**:
    - Create, edit, and delete tasks.
    - Mark tasks as completed with a checkbox.
    - Persist tasks using Hive for local storage.
    - Basic UI with a yellow theme.

- **Provider for State Management**:
    - Introduced `TodoProvider` (using the `provider` package) to centralize task management logic (add, edit, delete, sort).
    - `ChangeNotifierProvider` notifies widgets of data changes, reducing manual `setState` calls and improving code organization.
    - `Consumer<TodoProvider>` rebuilds the task list when data changes.
- **Light and Dark Mode**:
    - Added `ThemeProvider` to manage light and dark themes, persisted in Hive.
    - Defined `ThemeData` for each mode with custom colors (e.g., yellow for light, grey for dark).
    - Added a theme toggle button in the `AppBar` using `Provider.of<ThemeProvider>`.
    - Updated widgets (`TodoTile`, `DialogBox`, `MyButton`) to use `Theme.of(context)` for colors, ensuring theme consistency.
- **Sorting by Creation and Due Date**:
    - Extended tasks to include `creationDate` (set to `DateTime.now()`) and `dueDate` (optional, set via a `DatePicker` in `DialogBox`).
    - Added a dropdown in the `AppBar` to sort tasks by creation or due date, with logic in `TodoProvider` to handle sorting (null due dates sorted to the end).
- **Type Safety**:
    - Addressed type errors (e.g., casting `Object?` to `bool` or `DateTime?`) due to `List<List<Object?>>`.
   
- **Persistence**:
    - Used Hive to persist both tasks (`TODOLIST`) and theme preference (`isDarkMode`).

## How It Works
- **Architecture**:
    - The app uses `MultiProvider` in `main.dart` to provide `TodoProvider` and `ThemeProvider` to the widget tree.
    - `Homepage` consumes `TodoProvider` for task data and `ThemeProvider` for theming, using `Consumer` and `Provider.of` to access state.
    - Widgets like `TodoTile` and `DialogBox` are stateless, relying on theme and provider data for dynamic rendering.

- **Key Features**:
    - Task management (create, edit, delete, complete).
    - Sorting by creation or due date.
    - Light/dark mode theming.
    - Responsive UI with theme-aware colors for checkboxes, buttons, and backgrounds.
