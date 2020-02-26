# BVAnalytics
For a higher level overview please refer back to the [main github page](https://github.com/bazaarvoice/BVSwift).
## Introduction
This module essentially provides access into the BVPixel API. For more information please see [the documentation](https://developer.bazaarvoice.com/conversations-api/tutorials/bv-pixel)
## Configuration
1. Via the [existing configuration file](https://developer.bazaarvoice.com/mobile-sdks/ios/getting-started/installation#configuring-the-bvsdk). The keys that are pertinent are: `dryRunAnalytics` & `analyticsLocaleIdentifier` for development configuration of analytics, i.e., **don't transmit**, and configuration of the locale, respectively.
2. Via directly interacting with the BVManager, for example: `BVManager.sharedManager.addConfiguration(configuration)`
> (1) If you omit both keys then it defaults to production analytics with a locale set by the user's region. For more information about locale please refer to [the documentation](https://developer.bazaarvoice.com/mobile-sdks/ios/analytics-location).
## Example
Below is an example of sending a `BVAnalyticsEvent.transaction` event:
```
let items: [BVAnalyticsTransactionItem] =
[	BVAnalyticsTransactionItem(
		category: "fruit",
		imageURL: nil,
		name: "apples",
		price: 5.35,
		quantity: 10,
		sku: "sku0"),
	BVAnalyticsTransactionItem(
		category: "fruit",
		imageURL: nil,
		name: "oranges",
		price: 8.35,
		quantity: 10,
		sku: "sku1"),
	BVAnalyticsTransactionItem(
		category: "fruit",
		imageURL: nil,
		name: "bananas",
		price: 10.35,
		quantity: 10,
		sku: "sku2")	]

let transaction: BVAnalyticsEvent =
.transaction(
	items: items,
	orderId: "id-924859485",
	total: 20.75,
	city: "Austin",
	country: "USA",
	currency: "US",
	shipping: 7.50,
	state: "TX",
	tax: 3.25,
	additional: ["Store" : "Market", "Time" : "Busy"])

BVPixel.track(transaction)
```
For more examples please see [the various tests](https://github.com/bazaarvoice/BVSwift/tree/master/Tests/BVSwiftTests/BVAnalytics).
