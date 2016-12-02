# kairos
A iOS application that serves as a minimal and digital outlet for thoughts and moments. Log and store what matters, then go back and reflect.

### Dependencies:
* Xcode 8
* Swift 3
* Firebase (included in Pod file)
* FBSDK (included in Pod file)
* JTAppleCalendar (included in Pod file)

## Major Feature Table
| Feature       | Description   | Planned release  | Actual release | Deviation(s) |
| :-----------: |:-------------:| :---------------:| :-------------:| :-----------:|
| Facebook Login| Allows user to log into app via Facebook. | Alpha |  Alpha | No deviations. UI on login screen could use improvement. |
| Calendar      | Serves as the main navigation mechanism for the app. Comprised of a year, month, and day heirarchy. The year view displays months for each year (up to current year) and the month view displays a traditional month calendar where you can select a day (up to current date) to view your logged content for that date.|   Alpha		   |   Alpha/Beta   |   No deviations. |
| Day View      | Here is where the user will be able to log and view content for that date. Photo/video exists at the top in a collage-type manner, one audio clip at the bottom if the user has recorded one, and text filling out the middle. The user can switch between view and edit mode. When in edit mode they can add/remove content. In view mode, the representation of their content should be adjusted appropriately depending on the amount they have logged for that day. |   Beta 		   |        Beta/Final      |      Dynamic views have currently not been implemented. Support for video has not been implemented either. A photo/video viewer should be added as well.    |
| Daily Reminder | are neat      |    $1 		   |        x       |      x       |
| Logging Process      | centered      |   $12 		   |        x       |      x       |
| Settings | are neat      |    $1 		   |        x       |      x       |

-Login Screen

-Facebook Integration

-Navigation Hierarchy (Year, Month, Day)

-Calendar

-Day View (UI needs improvement)

-Logging process (persistence needs to be completed)



## Current list of bugs and unfinished features:
##### Bugs
* Color of current month in year view
* Color of un-selectable future months in year view
* Image scaling and rotation in day view
* Some months are not displaying all their days
* Date issue where at a certain time you can click on the next day to log
* Scroll view scrolls down too far
* Scroll view does not reset position after keyboard is dismissed

##### To-do's
* Local notifications are deprecated. Use UNUserNotifications for iOS 10+
* Dynamic views in day view in view mode
* Make video persist (as well as image bin)
* Implement video/photo viewer
* Implement cancel option when user is in edit mode
* Add waveform visualization for audio
* Improve speed of image download
* Implement image bin
* Improve all around UI
