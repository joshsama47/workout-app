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
*   **Personal Records:** The app tracks and displays users' personal records for a variety of exercises, including weight, reps, time, and distance.

## Current Task: Comprehensive Personal Record Tracking

### Plan and Steps

1.  **Create `RecordType` Enum:** A new enum, `RecordType`, was created to represent the different types of personal records that can be tracked (weight, reps, time, distance).
2.  **Update `PersonalRecord` Model:** The `PersonalRecord` model was updated to include a `RecordType` and a `values` map to store the record data in a more flexible way.
3.  **Refine `RecordType` Enum:** The `RecordType.weight` enum value was renamed to `RecordType.weightAndReps` to more accurately reflect that a personal record for a weight-based exercise is a combination of both weight and repetitions.
4.  **Update `Exercise` Model:** The `Exercise` model was updated to include a `recordType` field to associate each exercise with a specific type of personal record.
5.  **Update `default_exercises.dart`:** The `default_exercises.dart` file was updated to include the `recordType` for each exercise and to add new exercises with different record types.
6.  **Update `PersonalRecordCard` Widget:** The `PersonalRecordCard` widget was updated to handle the new `PersonalRecord` model and display the information appropriately based on the `RecordType`.
7.  **Update `PersonalRecordService`:** The `PersonalRecordService` was updated to handle the new `PersonalRecord` model.
8.  **Update `WorkoutService`:** The `WorkoutService` was updated to check for new personal records based on the new `PersonalRecord` model, and to correctly handle `weightAndReps` by finding the set with the highest weight, and if there are multiple sets with the same weight, using the one with the most reps.
9.  **Update `ProfileScreen`:** The `ProfileScreen` was updated to handle the new `PersonalRecord` model.
