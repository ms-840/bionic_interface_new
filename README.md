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
Creates and manages moving between screens

### Test Interface / Generator
Creates any necessary inputs for using the app without having a physical device to test with

# Things that still need to be added:
- [X] have the grip settings pop up wrap to fit the number of items available
- [X] change the first index of the grip settings to a house icon so its clear thats the home 
- [X] Possibly move the use thumbtoggling to the other setting setter screen
- [X] Add the information pop up for the training circles
- [ ] Move thumb toggling into the advanced settings class 
- [X] Have the direct actions line up better with each other
- [X] Ability to remove things from the grip settings listview
- [X] Add some sort of menu that takes you back to the home page even if the arrows are gone
- [ ] Popups for changing trigger settings ->  though this may be better to be in the emg page rather than grip settings?
- [ ] Adding ability to login + dealing with different account types 
- [ ] Add a way to back up and restore the clinician version of the advanced settings 
- [X] Figuring out best way to persist data between sessions (incl user data ) -> actually this should be handled by firebase 
- [ ] Make sure a default user is in the db at the start -> this should be firebase
- [ ] Make sure the data is saved to the persisting version every time a screen page is disposed and also when the general handler is disposed
- [X] Functionality of other features on emg signal page beyond just the slider 
- [ ] All of the Bluetooth integration -> still needs the protocols from the firmware, i don't think those exist yet
- [ ] Front page rehaul
- [ ] Make an advanced setting system in the general handler
- [ ] Remove local sql storage (replace with firebase)


