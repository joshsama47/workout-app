# Project Blueprint

## Overview

This document outlines the architecture, features, and design of the fitness application. The app is designed to help users track their workouts, monitor their progress, and stay motivated.

## Style, Design, and Features

### Style and Design

*   **Theme:** The app uses a modern, clean design with a focus on usability. The primary color is a deep purple, with a light and dark theme available.
*   **Typography:** The app uses the Google Fonts library to provide a clean and readable text style.
*   **Iconography:** The app uses Material Design icons to provide a consistent and intuitive user experience.

### Features

*   **User Authentication:** Users can create an account and log in to the app.
*   **Workout Creation:** Users can create custom workouts with a variety of exercises.
*   **Workout Tracking:** Users can track their workout sessions, including the exercises performed, sets, reps, and weight.
*   **Workout History:** Users can view their workout history to track their progress over time.
*   **Comprehensive Personal Record Tracking:** The app tracks and displays users' personal records for a variety of exercises, including weight and reps, time, and distance.
*   **Progress Visualization:** The app includes a progress section with dynamic charts to visualize key metrics from the user's workout history, including strength progression, volume progression, and endurance progression.

## Current Task: Workout Streak

### Plan and Steps

1.  **Update `WorkoutService`:** The `WorkoutService` was updated to include a `getWorkoutStreak` method to calculate the user's workout streak based on their workout history.
2.  **Update `ProfileScreen`:** The `ProfileScreen` was updated to use the `getWorkoutStreak` method to display the real workout streak.
