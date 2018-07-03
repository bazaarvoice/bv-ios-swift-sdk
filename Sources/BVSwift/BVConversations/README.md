

# BVConversations
For a higher level overview please refer back to the [main github page](https://github.com/bazaarvoice/BVSwift).
## Introduction
This module essentially provides access into the Conversations API. For more information please see [the documentation](https://developer.bazaarvoice.com/conversations-api)
## Configuration
1. Via the [existing configuration file](https://developer.bazaarvoice.com/mobile-sdks/ios/getting-started/installation#configuring-the-bvsdk). The key that is pertinent is: `apiKeyConversations`.
2. Via directly interacting with the BVManager, for example: `BVManager.sharedManager.addConfiguration(configuration)`
> (1) BVCurations holds a dependency on BVAnalytics because it sends analytic information, therefore, it inherits all of the same dependencies as BVAnalytics. For more information about [BVAnalytics](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVAnalytics).
## Example
Below is an example of sending a `BVQuestionQuery`:
```
let analyticsConfig: BVAnalyticsConfiguration =
	.configuration(
		Locale: Locale.autoupdatingCurrent,
		configType: .staging(clientId: "clientId"))

let conversationsConfig: BVConversationsConfiguration =
	.display(
		clientKey: "clientKey",
		configType: .production(clientId: "clientId"),
		analyticsConfig: analyticsConfig)

let questionQuery =
	BVQuestionQuery(productId: "productId")
		.include(.answers)
		.filter(.hasAnswers(true))
		.configure(conversationsConfig)
		.handler { (response: BVConversationsQueryResponse<BVQuestion>) in
			if case .failure(let error) = response {
				/// FAILURE
				return
			}

			guard case let .success(meta, questions) = response else {
				/// FAILURE
				return
			}

			/// SUCCESS
			print(meta)
			print(questions)
		}

questionQuery.async()

/// Or you can use the BVManager extension for BVConversations
BVManager.sharedManager.addConfiguration(curationsConfig)

guard  let questionQuery: BVQuestionQuery =
	BVManager.sharedManager.query(questionProductId: "productId") else {
		return
}

questionQuery
	.include(.answers)
		.filter(.hasAnswers(true))
		.configure(conversationsConfig)
		.handler { (response: BVConversationsQueryResponse<BVQuestion>) in
			if case .failure(let error) = response {
				/// FAILURE
				return
			}

			guard case let .success(meta, questions) = response else {
				/// FAILURE
				return
			}

			/// SUCCESS
			print(meta)
			print(questions)
		}

questionQuery.async()
```
Below is an example of sending a `BVQuestionSubmission`:
```
let analyticsConfig: BVAnalyticsConfiguration =
	.configuration(
		Locale: Locale.autoupdatingCurrent,
		configType: .staging(clientId: "clientId"))

let conversationsConfig: BVConversationsConfiguration =
	.display(
		clientKey: "clientKey",
		configType: .production(clientId: "clientId"),
		analyticsConfig: analyticsConfig)

let question: BVQuestion =
	BVQuestion(
		productId: "productId",
		questionDetails: "questionDetails",
		questionSummary: "questionSummary",
		isUserAnonymous: false)

guard let questionSubmission = BVQuestionSubmission(question) else {
	return nil
}

questionSubmission
	.configure(conversationsConfig)
	.add(.submit)
	.add(.campaignId("campaignId"))
	.add(.locale("en_US"))
	.add(.sendEmailWhenCommented(true))
	.add(.sendEmailWhenPublished(true))
	.add(.nickname("UserNickname"))
	.add(.email("me@developer.com"))
	.add(.identifier("UserId"))
	.add(.agree(true))
	.handler { result in
		if case let .failure(errors) = result {
			/// FAILURE
			return
		}

		guard case let .success(meta, result) = result else {
			return
		}

		/// SUCCESS
		print(meta)
		print(result)
	}

questionSubmission.async()

/// Or you can use the BVManager extension for BVConversations
guard let questionSubmission =
	BVManager.sharedManager.submission(question) else {
	return nil
}

questionSubmission
	.add(.submit)
	.add(.campaignId("campaignId"))
	.add(.locale("en_US"))
	.add(.sendEmailWhenCommented(true))
	.add(.sendEmailWhenPublished(true))
	.add(.nickname("UserNickname"))
	.add(.email("me@developer.com"))
	.add(.identifier("UserId"))
	.add(.agree(true))
	.handler { result in
		if case let .failure(errors) = result {
			/// FAILURE
			return
		}

		guard case let .success(meta, result) = result else {
			return
		}

		/// SUCCESS
		print(meta)
		print(result)
	}

questionSubmission.async()
```
For more examples please see [the various tests](https://github.com/bazaarvoice/BVSwift/tree/master/Tests/BVSwiftTests/BVConversations).
