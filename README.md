# Icnfnd - Icon Finder App
The test app for iconfinder.com service. 

## Test case
Write an iPhone application for icon finder ([iconfinder.com](http://iconfinder.com/)) service.

## Description
The application consists of a single screen, the iconfinder screen. At the top of this form is an input field for the search query and a search button. Below the input field is a table with the search results. Each cell of the table includes:
1. Icon
2. The largest icon size available (width and height with text)
3. List of Tags (if there are a lot of them, the first 10 are shown)

The data for the output is obtained from the API as a result of a search query. Provide caching of queries to reduce the number of calls to the API. Provide caching of icons (pictures). Provide output of possible errors. When clicking on a cell, the icon is saved to the phone gallery. 

## Requirements
App requirements:
1. Programming language: Swift
2. The application must support iOS 14 and above
3. The interface should be implemented using UIKit
4. It is forbidden to use any third-party libraries. The exception is libraries for working with SQLite, if SQLite will be used in the program
5. Create any 2 unit tests
6. Create any 2 UI tests
7. API (registration for api key is free): https://developer.iconfinder.com/reference/overview-1 (only free (not premium) bitmap icons should be included in the search results, limiting the output to png).
