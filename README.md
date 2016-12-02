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
| Facebook Login| Allows user to log into app via Facebook. | $1600 |  x |   x     |
| col 2 is      | centered      |   $12 		   |        x       |      x       |
| zebra stripes | are neat      |    $1 		   |        x       |      x       |

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
