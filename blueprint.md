# Workout Planner App Blueprint

## Overview

This document outlines the plan and progress for creating a workout planner application for Flutter. The app will feature a list of workouts, a detail screen for each workout, a favorites feature, and a workout-in-progress screen.

## Style, Design, and Features

### Version 1.0 (Initial)

*   **UI:** Modern, clean design with a dark theme.
*   **Fonts:** `google_fonts` for custom typography.
*   **State Management:** `provider` for theme management.
*   **Navigation:** `go_router` for routing between screens.
*   **Animations:** `lottie` for workout animations.
*   **Screens:**
    *   **Workout List Screen:** Displays a list of workouts.
    *   **Workout Detail Screen:** Shows workout details and animation.

### Version 1.1

*   **Project Structure:**
    *   `screens` directory for UI screens.
    *   `data` directory for workout data.
*   **UI Enhancements:**
    *   Workout list is now a `GridView`.
    *   Added `Hero` animations for transitions between the list and detail screens.

### Version 1.2

*   **Theming:**
    *   Implemented Material 3 theming using `ColorScheme.fromSeed` for a more modern and harmonized color palette.
*   **UI Enhancements:**
    *   Redesigned the workout cards on the home screen to display the Lottie animation directly.
    *   Added a gradient overlay to the workout cards to improve text legibility.
    *   Refined the card's shape and shadow for a more modern, "lifted" feel.

### Version 1.3

*   **Workout Detail Screen:**
    *   Added a "Start Workout" button to make the screen more interactive.
    *   Added a decorative container with a gradient to the top of the screen for a more polished look.

### Version 1.4

*   **Favorites Feature:**
    *   Added an `isFavorite` boolean to the `Workout` model.
    *   Created a `WorkoutProvider` to manage the state of workouts, including favorites.
    *   Added a `FavoritesScreen` to display a grid of the user's favorite workouts.
    *   Added favorite toggle icons to workout cards and the workout detail screen.
*   **Navigation:**
    *   Implemented a `BottomNavigationBar` to switch between the main workout list and the favorites screen.
*   **State Management:**
    *   Used a `MultiProvider` to provide both the `ThemeProvider` and `WorkoutProvider` to the app.

## Current Plan

### Step 1: Project Setup (Completed)

1.  **Add Dependencies:** Added `google_fonts`, `provider`, `go_router`, and `lottie` to `pubspec.yaml`.
2.  **Create `blueprint.md`:** Done.
3.  **Update `lib/main.dart`:** Set up the main app structure with `MaterialApp.router`, `ChangeNotifierProvider`, and a basic theme.

### Step 2: Create App Structure (Completed)

1.  **Create `screens`, `models`, `assets`, `data`, `providers`, and `widgets` directories.**

### Step 3: Build the Features (Completed)

1.  **Workout Model:** Created a `Workout` model class.
2.  **Workout Data:** Created a list of sample workouts.
3.  **Workout Screens:** Implemented `WorkoutListScreen`, `WorkoutDetailScreen`, and `WorkoutInProgressScreen`.
4.  **Routing:** Configured `go_router` to navigate between the screens.

### Step 4: Refactor and Enhance UI (Completed)

1.  **Restructure Project:** Moved screens and data into separate directories.
2.  **Improve UI:** Changed workout list to a `GridView` and added `Hero` animations.

### Step 5: Modernize UI and Theming (Completed)

1.  **Material 3 Theming:** Implemented Material 3 theming using `ColorScheme.fromSeed`.
2.  **Redesigned Workout Cards:** Created a reusable `WorkoutCard` widget and updated the workout list to use it.

### Step 6: Enhance Workout Detail Screen (Completed)

1.  **Add "Start Workout" Button:** Added a button to the detail screen.
2.  **Add Decorative Container:** Added a container with a gradient to the detail screen.

### Step 7: Add Favorites Feature (Completed)

1.  **Update `Workout` Model:** Added `isFavorite` property.
2.  **Create `WorkoutProvider`:** To manage workout state.
3.  **Create `FavoritesScreen`:** To display favorite workouts.
4.  **Update UI:** Added favorite buttons to `WorkoutCard` and `WorkoutDetailScreen`.
5.  **Add `BottomNavigationBar`:** For easy navigation between the main list and favorites.