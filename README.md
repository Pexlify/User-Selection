# Custom Multi User Selection in Visualforce

One of the most common components we’re asked to develop in Salesforce is a custom multi user selection. It can be handy for a variety of features you would need to develop. Salesforce allow you to select users for many of their own standard features but there isn’t an easy way to do so if you’re developing your own thing in Visualforce.

UserSelection
The idea behind our component is to store a map of the user Ids and the names of the user as you’d want to show the names of the users in the selection but would probably need the user Ids.

We prefer to base all of our Visualforce components on native Visualforce and Apex rather then Javascript. It’s then just easier to test our functionality without using automated UI tests such as Selenium tests. The disadvantage of using native Visualforce rather than Javascript is a bit slower feature since every button click the user will do would require a request to be sent to Salesforce.

We then add 2 methods to add and remove a user. When add is called we’re looking which users were selected in the available users multi picklist. When remove is called we’re looking which users were selected in the selected users multi picklist.

Another important part is to add 2 getter methods that return a list of SelectOption for each of the multi picklists.

Last we’ll add another filter method which will allow the user to filter and search for a specific user within the available users list.

The Visalforce would have 2 multi select lists, 2 buttons to add and remove and a search text input with a search button.

We used an HTML table to layout the table properly. You can then include this in any of your features and use the selectedUserIds list to process the users that were selected.