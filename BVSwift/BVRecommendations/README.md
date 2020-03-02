
# BVRecommendations
For a higher level overview please refer back to the [main github page](https://github.com/bazaarvoice/BVSwift).
## Introduction
This module essentially provides access into the BVRecommendations API.
## Configuration
1. Via the [existing configuration file](https://developer.bazaarvoice.com/mobile-sdks/ios/getting-started/installation#configuring-the-bvsdk). The key that is pertinent is: `apiKeyShopperAdvertising`.
2. Via directly interacting with the BVManager, for example: `BVManager.sharedManager.addConfiguration(configuration)`
> (1) BVCurations holds a dependency on BVAnalytics because it sends analytic information, therefore, it inherits all of the same dependencies as BVAnalytics. For more information about [BVAnalytics](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVAnalytics).
## Example
Below is an example of sending a `BVRecommendationsProfileQuery`:
```
let analyticsConfig: BVAnalyticsConfiguration =
	.configuration(
		Locale: Locale.autoupdatingCurrent,
		configType: .staging(clientId: "clientId"))

let recommendationsConfig: BVRecommendationsConfiguration =
	BVRecommendationsConfiguration.display(
		clientKey: "clientKey",
		configType: .production(clientId: "clientId"),
		analyticsConfig: analyticsConfig)

let profileQuery =
	BVRecommendationsProfileQuery()
	.configure(recommendationsConfig)
	.field(.brandId("brandId"))
	.field(.include(.interests))
	.field(.include(.categories))
	.field(.include(.brands))
	.field(.include(.recommendations))
	.handler { response in
		if case let .failure(errors) = response {
			/// FAILURE
			return
		}

		guard case let .success(meta, result) = response else {
			/// FAILURE
			return
		}

		/// SUCCESS
		print(meta)
		print(result)
	}

profileQuery.async()

/// Or you can use the BVManager extension for BVRecommendations
BVManager.sharedManager.addConfiguration(recommendationsConfig)

guard let profileQuery: BVRecommendationsProfileQuery =
BVManager.sharedManager.query() else {
	return
}

profileQuery
	.field(.brandId("brandId"))
	.field(.include(.interests))
	.field(.include(.categories))
	.field(.include(.brands))
	.field(.include(.recommendations))
	.handler { response in
		if case let .failure(errors) = response {
			/// FAILURE
			return
		}

		guard case let .success(meta, result) = response else {
			/// FAILURE
			return
		}

		/// SUCCESS
		print(meta)
		print(result)
	}

profileQuery.async()
```
For more examples please see [the various tests](https://github.com/bazaarvoice/BVSwift/tree/master/Tests/BVSwiftTests/BVRecommendations).
