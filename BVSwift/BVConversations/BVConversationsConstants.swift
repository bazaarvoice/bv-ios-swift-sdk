//
//  BVConversationsConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal struct BVConversationsConstants {
  static let bvProduct: String = "Conversations"
  static let apiVersion: String = "5.4"
  static let apiKey: String = "apiKeyConversations"
  static let clientKey: String = "clientId"
  static let parameterKey: String = "passkey"
  static let stagingEndpoint: String =
  "https://stg.api.bazaarvoice.com/data/"
  static let productionEndpoint: String =
  "https://api.bazaarvoice.com/data/"
  
  internal struct BVConversationsErrorInternal {
    static let key: String = "Errors"
    static let message: String = "Message"
    static let code: String = "Code"
  }
  
  internal struct BVQueryFilter {
    static let defaultField: String = "Filter"
    static let typeSeparatorField: String = "_"
    static let valueSeparatorField: String = ":"
  }
  
  internal struct BVQueryFilteredStat {
    static let defaultField: String = "FilteredStats"
  }
  
  internal struct BVQueryInclude {
    static let defaultField: String = "Include"
    static let limitSeparatorField: String = "_"
  }
  
  internal struct BVQuerySearch {
    static let defaultField: String = "Search"
  }
  
  internal struct BVProductId {
    static let defaultField: String = "productId"
  }
  
  internal struct BVQuerySort {
    static let defaultField: String = "Sort"
    static let typeSeparatorField: String = "_"
    static let valueSeparatorField: String = ":"
  }
  
  internal struct BVQueryStat {
    static let defaultField: String = "Stats"
  }
  
  internal struct BVQueryType {
    internal struct Keys {
      static let errors: String = "HasErrors"
      static let includes: String = "Includes"
      static let limit: String = "Limit"
      static let locale: String = "Locale"
      static let offset: String = "Offset"
      static let results: String = "Results"
      static let search: String = "Search"
      static let totalResults: String = "TotalResults"
      static let incentivizedstats: String = "incentivizedstats"
      static let productId: String = "productId"
      static let feature: String = "Feature"
      static let language: String = "language"
    }
  }
  
  internal struct BVAnswers {
    static let singularKey: String = "Answer"
    static let pluralKey: String = "Answers"
    static let getResource: String = "answers.json"
    static let postResource: String = "submitanswer.json"
    
    internal struct Keys {
      static let answerId: String = "Id"
      static let authorId: String = "AuthorId"
      static let campaignId: String = "CampaignId"
      static let categoryAncestorId: String = "CategoryAncestorId"
      static let contentLocale: String = "ContentLocale"
      static let hasPhotos: String = "HasPhotos"
      static let isBestAnswer: String = "IsBestAnswer"
      static let isBrandAnswer: String = "IsBrandAnswer"
      static let isFeatured: String = "IsFeatured"
      static let lastModeratedTime: String = "LastModeratedTime"
      static let lastModificationTime: String = "LastModificationTime"
      static let moderatorCode: String = "ModeratorCode"
      static let productId: String = "ProductId"
      static let questionId: String = "QuestionId"
      static let submissionId: String = "SubmissionId"
      static let submissionTime: String = "SubmissionTime"
      static let totalFeedbackCount: String = "TotalFeedbackCount"
      static let totalNegativeFeedbackCount: String =
      "TotalNegativeFeedbackCount"
      static let totalPositiveFeedbackCount: String =
      "TotalPositiveFeedbackCount"
      static let userLocation: String = "UserLocation"
    }
  }
  
  internal struct BVAuthors {
    static let singularKey: String = "Author"
    static let pluralKey: String = "Authors"
    static let getResource: String = "authors.json"
    
    internal struct Keys {
      static let additionalField: String = "AdditionalField"
      static let authorId: String = "Id"
      static let contentLocale: String = "ContentLocale"
      static let contextDataValue: String = "ContextDataValue"
      static let hasPhotos: String = "HasPhotos"
      static let hasVideos: String = "HasVideos"
      static let lastModeratedTime: String = "LastModeratedTime"
      static let moderatorCode: String = "ModeratorCode"
      static let submissionTime: String = "SubmissionTime"
      static let totalAnswerCount: String = "TotalAnswerCount"
      static let totalQuestionCount: String = "TotalQuestionCount"
      static let totalReviewCount: String = "TotalReviewCount"
      static let userLocation: String = "UserLocation"
    }
  }
  
  internal struct BVBadge {
    
    internal struct Keys {
      static let identifier: String = "Id"
      static let contentType: String = "ContentType"
      static let badgeType: String = "BadgeType"
    }
    
    internal struct BVBadgeCategory {
      static let merit: String = "Merit"
      static let affiliation: String = "Affiliation"
      static let rank: String = "Rank"
    }
  }
  
  internal struct BVCategories {
    static let key: String = "Categories"
    
    internal struct Keys {
      static let categoryId: String = "Id"
    }
  }
  
  internal struct BVComments {
    static let singularKey: String = "Comment"
    static let pluralKey: String = "Comments"
    static let getResource: String = "reviewcomments.json"
    static let postResource: String = "submitreviewcomment.json"
    
    internal struct Keys {
      static let commentId: String = "Id"
      static let title: String = "Title"
      static let commentText: String = "CommentText"
      static let reviewId: String = "ReviewId"
      static let campaignId: String = "CampaignId"
      static let userNickname: String = "UserNickname"
      static let authorId: String = "AuthorId"
      static let userLocation: String = "UserLocation"
      static let contentLocale: String = "ContentLocale"
      static let submissionId: String = "SubmissionId"
      static let submissionTime: String = "SubmissionTime"
      static let lastModeratedTime: String = "LastModeratedTime"
      static let lastModificationTime: String = "LastModificationTime"
      static let totalFeedbackCount: String = "TotalFeedbackCount"
      static let totalPositiveFeedbackCount: String =
      "TotalPositiveFeedbackCount"
      static let totalNegativeFeedbackCount: String =
      "TotalNegativeFeedbackCount"
      static let isSyndicated: String = "IsSyndicated"
      static let badges: String = "Badges"
      static let syndicationSource: String = "SyndicationSource"
      
      /// Filter Specific
      static let categoryAncestorId: String = "CategoryAncestorId"
      static let isFeatured: String = "IsFeatured"
      static let moderatorCode: String = "ModeratorCode"
      static let productId: String = "ProductId"
    }
  }
    
    internal struct BVReviewHighlights {
        
        static let stagingEndpoint: String = "https://rh-stg.nexus.bazaarvoice.com/"
        static let productionEndpoint: String = "https://rh.nexus.bazaarvoice.com/"
        
        static let getResource: String = "highlights/v3/1/"

        static let singularKey: String = "subject"
        static let pluralKey: String = "subjects"
    }
    
  internal struct BVFeedback {
    static let singularKey: String = "Feedback"
    static let pluralKey: String = "Feedbacks"
    static let postResource: String = "submitfeedback.json"
  }
  
  internal struct BVConversationsSortOrder {
    static let ascending: String = "asc"
    static let descending: String = "desc"
  }
  
    internal struct BVNativeReviews {
        static let key: String = "NativeReviews"
    }
  
  internal struct BVProducts {
    static let pluralKey: String = "Products"
    static let singularKey: String = "Product"
    static let getResource: String = "products.json"
    
    internal struct Keys {
      static let productId: String = "Id"
      static let averageOverallRating: String = "AverageOverallRating"
      static let categoryAncestorId: String = "CategoryAncestorId"
      static let categoryId: String = "CategoryId"
      static let helpfulness: String = "Helpfulness"
      static let isActive: String = "IsActive"
      static let isDisabled: String = "IsDisabled"
      static let lastAnswerTime: String = "LastAnswerTime"
      static let lastQuestionTime: String = "LastQuestionTime"
      static let lastReviewTime: String = "LastReviewTime"
      static let lastStoryTime: String = "LastStoryTime"
      static let name: String = "Name"
      static let rating: String = "Rating"
      static let ratingsOnlyReviewCount: String = "RatingsOnlyReviewCount"
      static let totalAnswerCount: String = "TotalAnswerCount"
      static let totalQuestionCount: String = "TotalQuestionCount"
      static let totalReviewCount: String = "TotalReviewCount"
      static let totalStoryCount: String = "TotalStoryCount"
    }
  }
  
  internal struct BVPhoto {
    internal struct Keys {
      static let contentTypeKey: String = "contenttype"
      static let dataKey: String = "photo"
      static let passKey: String = "passkey"
    }
  }
  
  internal struct BVProductStatistics {
    static let singularKey: String = "ProductStatistic"
    static let pluralKey: String = "ProductStatistics"
    static let getResource: String = "statistics.json"
    
    internal struct Keys {
      static let contentLocale: String = "ContentLocale"
      static let productId: String = "ProductId"
    }
  }
  
  internal struct BVQuestions {
    static let singularKey: String = "Question"
    static let pluralKey: String = "Questions"
    static let getResource: String = "questions.json"
    static let postResource: String = "submitquestion.json"
    
    internal struct Keys {
      static let questionId: String = "Id"
      static let authorId: String = "AuthorId"
      static let campaignId: String = "CampaignId"
      static let categoryAncestorId: String = "CategoryAncestorId"
      static let categoryId: String = "CategoryId"
      static let contentLocale: String = "ContentLocale"
      static let hasAnswers: String = "HasAnswers"
      static let hasBestAnswer: String = "HasBestAnswer"
      static let hasBrandAnswers: String = "HasBrandAnswers"
      static let hasPhotos: String = "HasPhotos"
      static let hasStaffAnswers: String = "HasStaffAnswers"
      static let hasTags: String = "HasTags"
      static let hasVideos: String = "HasVideos"
      static let isFeatured: String = "IsFeatured"
      static let isSubjectActive: String = "IsSubjectActive"
      static let lastApprovedAnswerSubmissionTime: String =
      "LastApprovedAnswerSubmissionTime"
      static let lastModeratedTime: String = "LastModeratedTime"
      static let lastModificationTime: String = "LastModificationTime"
      static let moderatorCode: String = "ModeratorCode"
      static let productId: String = "ProductId"
      static let submissionId: String = "SubmissionId"
      static let submissionTime: String = "SubmissionTime"
      static let summary: String = "Summary"
      static let totalAnswerCount: String = "TotalAnswerCount"
      static let totalFeedbackCount: String = "TotalFeedbackCount"
      static let totalNegativeFeedbackCount: String =
      "TotalNegativeFeedbackCount"
      static let totalPositiveFeedbackCount: String =
      "TotalPositiveFeedbackCount"
      static let userLocation: String = "UserLocation"
    }
  }
  
  internal struct BVConversationsQueryFilter {
    internal struct Keys {
      static let id: String = "Id"
      static let productId: String = "ProductId"
    }
  }
  
  internal struct BVConversationsFilterOperator {
    
    internal struct Keys {
      static let greaterThan: String = "gt"
      static let greaterThanOrEqualTo: String = "gte"
      static let lessThan: String = "lt"
      static let lessThanOrEqualTo: String = "lte"
      static let equalTo: String = "eq"
      static let notEqualTo: String = "neq"
    }
  }
    
      
  internal struct BVMultiProductQuery {
       static let singularKey: String = "response"
       static let pluralKey: String = "responses"
       static let postResource: String = "initiateSubmit.json"
      }
      
 internal struct BVProgressiveReviewSubmission {
        static let singularKey: String = "response"
        static let pluralKey: String = "responses"
        static let postResource: String = "progressiveSubmit.json"
      }
      

  
  internal struct BVReviews {
    static let singularKey: String = "Review"
    static let pluralKey: String = "Reviews"
    static let getResource: String = "reviews.json"
    static let postResource: String = "submitreview.json"
    
    internal struct Keys {
      static let reviewId: String = "Id"
      static let authorId: String = "AuthorId"
      static let campaignId: String = "CampaignId"
      static let categoryAncestorId: String = "CategoryAncestorId"
      static let contentLocale: String = "ContentLocale"
      static let hasComments: String = "HasComments"
      static let hasPhotos: String = "HasPhotos"
      static let hasTags: String = "HasTags"
      static let hasVideos: String = "HasVideos"
      static let helpfulness: String = "Helpfulness"
      static let isFeatured: String = "IsFeatured"
      static let isRatingsOnly: String = "IsRatingsOnly"
      static let isRecommended: String = "IsRecommended"
      static let isSubjectActive: String = "IsSubjectActive"
      static let isSyndicated: String = "IsSyndicated"
      static let lastModeratedTime: String = "LastModeratedTime"
      static let lastModificationTime: String = "LastModificationTime"
      static let moderatorCode: String = "ModeratorCode"
      static let productId: String = "ProductId"
      static let rating: String = "Rating"
      static let submissionId: String = "SubmissionId"
      static let submissionTime: String = "SubmissionTime"
      static let totalCommentCount: String = "TotalCommentCount"
      static let totalFeedbackCount: String = "TotalFeedbackCount"
      static let totalNegativeFeedbackCount: String =
      "TotalNegativeFeedbackCount"
      static let totalPositiveFeedbackCount: String =
      "TotalPositiveFeedbackCount"
      static let userLocation: String = "UserLocation"
      static let contextDataValue: String = "ContextDataValue"
      static let secondaryRating: String = "SecondaryRating"
      static let additionalField: String = "AdditionalField"
      static let tagDimension: String = "tag"
    }
  }
  
  internal struct BVFilterReviews{
    
    static let singularKey: String = "feature"
    static let pluralKey: String = "features"
    static let getResource: String = "data/features.json"
    
  }
  
  internal struct BVSyndicationSource {
    internal struct Keys {
      static let logoImageUrl: String = "LogoImageUrl"
      static let contentLink: String = "ContentLink"
      static let name: String = "Name"
    }
  }
  
  internal struct BVUAS {
    static let singularKey: String = "Authentication"
    static let pluralKey: String = "Authentications"
    static let postResource: String = "authenticateuser.json"
  }
  
  internal struct BVVideo {
    static let singularKey: String = "Video"
    static let pluralKey: String = "Videos"
  }
}

internal extension Bundle {
    class var conversationsApiVersion: String {
      return BVConversationsConstants.apiVersion
  }
}

internal let defaultSDKParameters: BVURLParameters =
  [
    BVConstants.apiVersionField: Bundle.conversationsApiVersion,
    BVConstants.appIdField: Bundle.mainBundleIdentifier,
    BVConstants.appVersionField: Bundle.releaseVersionNumber,
    BVConstants.buildNumberField: Bundle.buildVersionNumber,
    BVConstants.sdkVersionField: Bundle.bvSdkVersion
]
