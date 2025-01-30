# Rebel Bionics Prosthetic Interface

Interface for a prosthetic hand developed by [Rebel Bionics](https://rebelbionics.com/)

## Functions 

The main functions of this app are to:
1. Visually plot the Electromyographic (EMG) data from two sensors sent wirelessly via bluetooth
2. Allow the user to change the rules/muscle activation patterns associated with a grip

More functions possibly to come

## Code structure

While this may change, the main components of this app will be:

### General Operations Handler

Contains methods, functions, objects which are necessary for general functioning. May be unnecessary, we will see.
This would also be the class which carries data between screens in cases where direct data transfers are not possible.

### Data Handler
Contains all handling and passing of data between classes

### BLE Handler
Handles all direct BLE interaction of the app. This class/file should be the only one with any references to the BLE packages

### Route Handler 
Creates and manages moving between screens. This should ideally be changed to work with GoRouter for better scalability and condition trees.

### Test Interface / Generator
Creates any necessary inputs for using the app without having a physical device to test with

# Things that still need to be added:
- [ ] Move thumb toggling into the advanced settings class
- [ ] Popups for changing trigger settings ->  though this may be better to be in the emg page rather than grip settings?
- 
- [ ] Make a function that just updates the data on both BLE and firebase if a user is connected. This should happen x seconds after the last thing has been changed or when the page exits
- [ ] All of the Bluetooth integration -> still needs the protocols from the firmware, i don't think those exist yet

- [ ] Make an advanced setting system in the general handler
- [X] Figure out how to best way to handle clinician accounts
- [ ] Ensure persistence even when no user is logged in?


- [ ] Make sure the advanced settings update as they are supposed to when a config is updated 
- [ ] Standardize grip png  sizes and same direction
- [ ] Add Art to splash screen 
- [ ] Play with start page buttons

