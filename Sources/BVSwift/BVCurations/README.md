# BVCurations
For a higher level overview please refer back to the [main github page](https://github.com/bazaarvoice/BVSwift).
## Introduction
This module essentially provides access into the Curations API. For more information please see [the documentation](https://developer.bazaarvoice.com/curations-api)
## Configuration
1. Via the [existing configuration file](https://developer.bazaarvoice.com/mobile-sdks/ios/getting-started/installation#configuring-the-bvsdk). The key that is pertinent is: `apiKeyCurations`.
2. Via directly interacting with the BVManager, for example: `BVManager.sharedManager.addConfiguration(configuration)`
> (1) BVCurations holds a dependency on BVAnalytics because it sends analytic information, therefore, it inherits all of the same dependencies as BVAnalytics. For more information about [BVAnalytics](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVAnalytics).
## Example
Below is an example of sending a `BVCurationsFeedItemQuery`:
```
let analyticsConfig: BVAnalyticsConfiguration =
	.configuration(
		Locale: Locale.autoupdatingCurrent,
		configType: .staging(clientId: "clientId"))

let curationsConfig: BVCurationsConfiguration =
	.display(
		clientKey: "clientKey",
		configType: .production(clientId: "clientId"),
		analyticsConfig: analyticsConfig)

let feedItemQuery =
	BVCurationsFeedItemQuery()
	.configure(curationsConfig)
	.field(.before(Date()))
	.handler { response in
		if case let .failure(errors) = response {
			/// FAILURE
			return
		}

		guard case let .success(meta, results) = response else {
			/// FAILURE
			return
		}

		// SUCCESS
		print(meta)
		print(results)
	}

feedItemQuery.async()

/// Or you can use the BVManager extension for BVCurations
BVManager.sharedManager.addConfiguration(curationsConfig)

guard  let feedItemQuery: BVCurationsFeedItemQuery =
	BVManager.sharedManager.query(10) else {
		return
}

feedItemQuery
	.field(.before(Date()))
	.handler { response in
		if case let .failure(errors) = response {
			/// FAILURE
			return
		}

		guard case let .success(meta, results) = response else {
			/// FAILURE
			return
		}

		// SUCCESS
		print(meta)
		print(results)
	}

feedItemQuery.async()
```
For more examples please see [the various tests](https://github.com/bazaarvoice/BVSwift/tree/master/Tests/BVSwiftTests/BVCurations/Display).
