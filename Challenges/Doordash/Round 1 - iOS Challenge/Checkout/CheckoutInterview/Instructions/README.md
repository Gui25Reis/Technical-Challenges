# Confidentiality Notice

**This interview exercise and all associated materials are confidential and proprietary to DoorDash, Inc.**

By accessing these materials, you agree not to share, publish, or distribute any part of this exercise or your solution.

**Violation of this agreement may result in disqualification from consideration for employment at DoorDash.**

---

# DoorDash TPS: Building a checkout page

## Background
 
This coding challenge is designed to assess your ability to implement a simple, API-driven UI based on a given design specification. Specifically, your tasks are to:

1. Consume the data from the `CheckoutService` API.
2. Populate the UI according to the specifications outlined in `Checkout.png` and `checkout_recording.mov`.
3. When the submit button is tapped, submit the order with the `CheckoutService` and transition to the order status page as specified in the `Checkout.png`.

**Important**: This assessment is focused on evaluating your individual knowledge of iOS development. Please refrain from using any third party tools such as AI or JSON generators, and rely solely on your expertise.

## Technology

The project is set up to use both `UIKit` & `SwiftUI`. If you wish to use `SwiftUI`, simply delete the `UIKIT` Swift compiler custom flag from the project build settings.

* Please use APIs that are available on iOS 17+. Do not change the iOS Deployment Target.
* Please use native APIs for layouts. You may use `SwiftUI` or `UIKit` APIs such as `NSLayoutConstraints`, `Interface Builder`, or `Visual Format Language`.

## Where to start

A `CheckoutService` class is provided, which exposes a `fetchOrder` function for retrieving data from the mock network session and a `submitOrder` function to submit the order with the mock network session. These functions can be updated as needed as you work on the project. The `FakeNetworkSession` should not be edited.

The floating button on the bottom of the screen is provided for you and you can add the appropriate action to submit the order and transition to the status page.

## Some files you should know about

`Checkout.png` `checkout_recording.mov` - Design-provided UI specs for the checkout screen. This will show you what you need to build.
`CheckoutService.swift` `CheckoutServiceAsync.swift` `CheckoutServiceCombine.swift` - Provides a function for retrieving data and submitting an order using a mock API.
`OrderResponse.json` - Provides the mocked API response for the order.
`SubmissionResponse.json` - Provides the mocked API response for the submission of the order.

## Some quick pointers:

1. You have limited time (about 45 minutes) so move quickly!
2. Your code does not need to be perfect, but you should still try to build in a clean & maintainable fashion. If you want to make a tradeoff for speed, mention it & explain why you're doing so.
3. If you are unclear about requirements, clarify! Your interviewer is there to help.

## API Schema Details

### fetchOrder response data

id: String (non-nil)
items.name: String (non-nil)
items.display_price: String (nullable) - the item's displayable price. If `null`, the price should be "Free".

### submitOrder response data

status: String (non-nil) - either "preparing_order", "delivery_in_progress", or "delivered".

## AI Usage Guidelines

For this TPS coding interview:

• ❌ AI chatbots (e.g. ChatGPT, DeepSeek) are not permitted

• ❌ AI code completion (e.g. Xcode predictions, CoPilot) is not permitted

This assessment is focused on evaluating your individual knowledge of iOS development. Please rely solely on your own expertise.

