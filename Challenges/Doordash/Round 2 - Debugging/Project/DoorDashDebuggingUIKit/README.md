# Project Bug Report

## QA team has tested our app and has found quite a few bugs! Here is a bug report outlining the problem and how to reproduce. Please work with your teammate to identify the issue and needed code changes to address the bugs.

## Bugs

**Legal link broken**
- Steps to Reproduce
  - On the account page, tap on the legal cell
- Expected Result
  - The app navigates to the legal page
- Actual Result
  - The app stays on the account page

-------------------------------------

**Push notification UI**
- Steps to Reproduce
  - On the account page, tap on push notification
- Expected Result
  - The push notification is turned on, and the text is updated.
- Actual Result
  - The push notification is turned on, and the text still says ”you will not receive notifications for your orders”.

-------------------------------------

**DashPass Toggle**
- Steps to Reproduce
  - On the account page, tap on the DashPass cell
  - On DashPass page, turn on DashPass subscription
  - Go back to the account page
  - Re-enter DashPass page.
- Expected Result
  - DashPass subscription is turned on
- Actual Result
  - DashPass remains off.

-------------------------------------

**Dark Mode Notifications**
- Steps to Reproduce
  - On the Account page, tap on the Dark Mode cell
  - On Dark Mode page, turn on the Dark Mode toggle
  - Go back to Account page, re-enter Dark Mode page
  - Repeat several times
- Expected Result
  - Dark Mode notification should appear only once after switching the toggle
- Actual Result
  - Dark Mode notification is presented multiple times
  
-------------------------------------

**Payment Page Empty**
- Steps to Reproduce
  - On the account page, tap on payment cell
- Expected Result
  - A list of payment methods are displayed
- Actual Result
  - The payment page is empty.

-------------------------------------

**Payment Title UI**
- Steps to Reproduce
  - On the payment page, once the payment methods are displayed
- Expected Result
  - Payment title is displayed next to the payment method icon on the left
- Actual Result
  - Payment method title is being displayed on the right.

-------------------------------------

**Order Cart Crash**
- Steps to Reproduce
  - Open the order cart via tapping the pill
- Expected Result
  - User is able to view the cart page
- Actual Result
  - The app crashes

-------------------------------------

**Cart Item UI**
- Steps to Reproduce
  - On the account page, the user taps on the cart pill on the bottom.
- Expected Result
  - The images for cart items should be displayed
- Actual Result
  - The images for cart items are missing.

-------------------------------------

**Cart Item Refresh**
- Steps to Reproduce
  - On the account page, the user taps on the cart pill on the bottom.
  - Tap on the +/- multiple times
- Expected Result
  - The total price and item count always up to date
- Actual Result
  - Sometimes the total price and item count doesn’t refresh.
  
-------------------------------------

**Orders Tab Crash**
- Steps to Reproduce
  - Tap on the orders tab
- Expected Result
  - The previous orders should be displayed
- Actual Result
  - The app crashes.

-------------------------------------

**Delete Payment Failure**
- Steps to Reproduce
  - On the payment page, swipe left on a payment method to delete it
- Expected Result
  - The payment method is deleted
- Actual Result
  - The payment page crashed.
  
-------------------------------------
