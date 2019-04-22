Weather
======

This repository contains a sample app for requesting Darksky API, to do weather forecast.



---
# Existing Functionalities

The app is currently able to forecast weather  from Darksky API, and show it in textView.

* When the app loads, it will forecast the Weather from input with Darksky API, and show it in the textView
* Upon changing the Location (Latitude and Longitude) and tap the Forecast button, it will try to get the Forecast for the new inputted Location.

---
# Development Steps

1. Create new project based on single view app
2. Create folders for MVVM pattern
3. Add WeatherViewController and Design the UI layout to show the forecast
4. Add Networking Layer to handle the Darksky API
5. Add Models and ViewModel, that will show the Forecast at WeatherViewController
6. Add LocationManager to detect current user location
7. Add Unit Tests to test the process


