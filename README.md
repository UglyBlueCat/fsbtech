This project includes cocoapods libraries - please open fsbtech.xcworkspace.

#FSB – iOS Developer Technical Task 2015

This is a technical task for FSB Technology iOS Developer candidates. It requires the creation of a simple iOS app. The task should take no more than four hours. The use of 3rd party libraries (and dependency management) is accepted and encouraged. Use either Objective-C or Swift. Please submit your final project via GitHub, Bitbucket or simply email the compressed sources.

##Requirement

Using the API endpoint

* GET http://fast-gorge.herokuapp.com/contacts

Save the results of the request using Core Data (or another local database) so that the app can still be used offline after first successful connection.

Create an app with two screens (code, storyboards or xib).

###Screen1
UITableView or UICollectionView - Cell action should take you to Screen2.

Cell content

- first_name
- surname

###Screen2
Display the following content

- View title
- first_name
- surname
- address
- phone_number
- email
- createdAt
- updatedAt

###Bonus
Based on the contact’s email address, use http://avatars.adorable.io to generate a unique avatar for each of the contacts. To be shown on both screens.
