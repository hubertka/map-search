# Mapkit and Maps Search (MapKitTutorial)
A maps app with location search using a UITableView, and placemark annotations with a button for driving directions

Created by using the tutorial "iOS Tutorial: How to search for location and display results using Apple’s MapKit" by Robert Chen.

Linked: https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/

This project was created to learn how to build a location reminders section for the previous Reminders app (link). The first step was to learn how to use iOS's MapKit to display a map view, enable search for locations, adding an annotation of a selected location search item, and to use the annotation's callout to link to another action. This project will be encapsulated into the Reminders app project as part of the "Remind me at location" feature.

This project covers my first use of iOS's MapKit, Core Location services (such as CLLocationManager), as well as understanding how Search can be implemented in iOS development (of which there are several quirks that complicate a beginner's learning process). The project sets up user permissions and prompts for location data, requests for location data via CLLocationManager and it's delegate methods, creates a map view in Interface Builder, and sets up a map view zoom to user location via CLLocationManager delegate methods and the ".setRegion" method. 

Search is implemented in code using UISearchController, which includes it's own searchBar, searchResultsController, and searchResultsUpdater - using UISearchController lead to a lot of confusion at the beginning, as I was trying to use all previous workflows, by placing UI elements in IB and then linking them up. However UISearchController is not implemented in such a way, and is easiest to implement search via code. A table view is implemented in IB to act as the search results table view. 
