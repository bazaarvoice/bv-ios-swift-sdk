//
//  WriteReviewView.swift
//  BVSwiftDemo
//
//  Created by Rahul on 30/06/26.
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import SwiftUI
import UIKit
import BVSwift
import UniformTypeIdentifiers

/// Recipient for loading state notifications triggered from the ViewModel
class SwiftUIWriteReviewDelegate: ObservableObject, WriteReviewViewControllerDelegate {
    @Published var isLoading = false
    
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
        }
    }
}

struct WriteReviewView: View {
    let viewModel: WriteReviewViewModel
    @ObservedObject var delegate = SwiftUIWriteReviewDelegate()
    
    // UI Forms States mimicking form fields
    @State private var recommendProduct: Bool = true
    @State private var rating: Int = 0
    @State private var reviewTitle: String = ""
    @State private var reviewDetails: String = ""
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var sendEmailAlert: Bool = true
    @State private var selectedImage: UIImage? = nil
    @State private var selectedVideoURL: URL? = nil
    @State private var selectedVideoName: String? = nil
    
    // Content Coach States
    @State private var coachTokens: [String] = []
    @State private var matchedTokens: [String] = []
    
    @State private var showImagePicker: Bool = false
    @State private var showVideoPicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 1. Product Details Header View
                HStack(spacing: 16) {
                    if let imageURL = viewModel.productImageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            default:
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(UIColor.bazaarvoiceNavy))
                            }
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    } else {
                        Image("placeholder")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.productName ?? "")
                            .font(.headline)
                            .foregroundColor(Color(UIColor.bazaarvoiceNavy))
                        
                        if let ratingValue = viewModel.productRating {
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: Double(index) < ratingValue ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .border(Color(.separator), width: 0.5)
                
                // 2. Main Form Fields
                Form {
                    // Recommendation Toggle
                    Section {
                        Toggle(UserFormConstants.recommendProductSwitchText, isOn: $recommendProduct)
                            .toggleStyle(SwitchToggleStyle(tint: Color(UIColor.bazaarvoiceNavy)))
                    }
                    
                    // Rating Star Input
                    Section(header: Text(UserFormConstants.ratingStarsTitle).foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                        HStack {
                            Spacer()
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(star <= rating ? .yellow : .gray)
                                    .onTapGesture {
                                        rating = star
                                    }
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Review Title Input
                    Section(header: Text(UserFormConstants.reviewTitleFieldTitle).foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                        TextField(UserFormConstants.reviewTitleFieldText, text: $reviewTitle)
                    }
                    
                    // NEW Content Coach Section placed above "Your Review" field
                    if !coachTokens.isEmpty {
                        Section(header: Text("Review Content Coach suggestions").foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Mention these keywords to make your review even better:")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                
                                // Scrollable Row displaying Review Suggestion Chips
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(coachTokens, id: \.self) { token in
                                            let isMatched = matchedTokens.contains { $0.caseInsensitiveCompare(token) == .orderedSame }
                                            
                                            HStack(spacing: 4) {
                                                if isMatched {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 10, weight: .bold))
                                                }
                                                Text(token)
                                                    .font(.system(size: 13, weight: .medium))
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(isMatched ? Color.green.opacity(0.15) : Color(.systemGray6))
                                            .foregroundColor(isMatched ? Color.green : Color.primary)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(isMatched ? Color.green.opacity(0.4) : Color.clear, lineWidth: 1)
                                            )
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // Review TextEditor details with dynamic word parsing callback
                    Section(header: Text(UserFormConstants.reviewDetailsFieldTitle).foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                        TextEditor(text: $reviewDetails)
                            .frame(minHeight: 120)
                            .onChange(of: reviewDetails) { newValue in
                                 let snapshot = newValue
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                     if reviewDetails == snapshot {
                                         checkMatchedTokens(for: snapshot)
                                     }
                                 }
                             }
                    }
                    
                    // Nickname Input
                    Section(header: Text(UserFormConstants.userNicknameFieldTitle).foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                        TextField(UserFormConstants.userNicknameFieldText, text: $nickname)
                    }
                    
                    // User Email Input
                    Section(header: Text(UserFormConstants.userEmailFieldTitle).foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                        TextField(UserFormConstants.userEmailFieldText, text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    // Adding Photo
                    Section(header: Text(UserFormConstants.photoTitle).foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                        HStack {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                            }
                            Spacer()
                            Button(action: {
                                showImagePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                    Text(selectedImage == nil ? "Add Photo" : "Change Photo")
                                }
                                .foregroundColor(Color(UIColor.bazaarvoiceNavy))
                            }
                        }
                    }
                    
                    // Adding Video (matches the `addVideoButton` in UIKit WriteReviewViewController)
                    Section(header: Text("Video Submission").foregroundColor(Color(UIColor.bazaarvoiceNavy))) {
                        HStack {
                            if let selectedVideoName = selectedVideoName {
                                Text(selectedVideoName)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                showVideoPicker = true
                            }) {
                                HStack {
                                    Image(systemName: "video")
                                    Text(selectedVideoName == nil ? "Add Video" : "Change Video")
                                }
                                .foregroundColor(Color(UIColor.bazaarvoiceNavy))
                            }
                        }
                    }
                    
                    // May we contact you switch
                    Section {
                        Toggle(UserFormConstants.sendEmailAlertWhenPublishedFieldText, isOn: $sendEmailAlert)
                            .toggleStyle(SwitchToggleStyle(tint: Color(UIColor.bazaarvoiceNavy)))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: submitReview) {
                        Text(NavigationBarButtonNames.submit)
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.bazaarvoiceNavy))
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                MediaPicker(
                    selectedImage: $selectedImage,
                    selectedVideoURL: .constant(nil),
                    selectedVideoName: .constant(nil),
                    mediaTypes: [UTType.image.identifier as String]
                )
            }
            .sheet(isPresented: $showVideoPicker) {
                MediaPicker(
                    selectedImage: .constant(nil),
                    selectedVideoURL: $selectedVideoURL,
                    selectedVideoName: $selectedVideoName,
                    mediaTypes: [UTType.movie.identifier as String, UTType.video.identifier as String]
                )
            }
            
            // 3. Loading Indicator Overlay (matches Delegate callbacks)
            if delegate.isLoading {
                ZStack {
                    Color.black.opacity(0.35)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear {
            loadSuggestedCoachTokens()
        }
    }
    
    /// Queries the Content Coach on init to gather list of suggestions
    private func loadSuggestedCoachTokens() {
        viewModel.fetchReviewTokens { tokens, error in
            if let tokens = tokens {
                DispatchQueue.main.async {
                    self.coachTokens = tokens
                }
            }
        }
    }
    
    /// Submits active text progress to match used keys against coach suggestion tokens
    private func checkMatchedTokens(for text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.matchedTokens = []
            return
        }
        
        viewModel.submitMatchedTokens(reviewText: text) { tokens, error in
            if let tokens = tokens {
                DispatchQueue.main.async {
                    self.matchedTokens = tokens
                }
            }
        }
    }
    
    /// Synchronizes local visual state switches with the Dictionary expected by WriteReviewViewModel and submits.
    private func submitReview() {
        let dict = viewModel.reviewSubmissionDictionary
        dict.setValue(recommendProduct, forKey: UserFormConstants.recommendProductSwitchKey)
        dict.setValue(rating > 0 ? rating : nil, forKey: UserFormConstants.ratingStarsKey)
        dict.setValue(reviewTitle.isEmpty ? nil : reviewTitle, forKey: UserFormConstants.reviewTitleFieldKey)
        dict.setValue(reviewDetails.isEmpty ? nil : reviewDetails, forKey: UserFormConstants.reviewDetailsFieldKey)
        dict.setValue(nickname.isEmpty ? nil : nickname, forKey: UserFormConstants.userNicknameFieldKey)
        dict.setValue(email.isEmpty ? nil : email, forKey: UserFormConstants.userEmailFieldKey)
        dict.setValue(selectedImage, forKey: UserFormConstants.photoKey)
        dict.setValue(sendEmailAlert, forKey: UserFormConstants.sendEmailAlertWhenPublishedFieldKey)
        
        if let videoURL = selectedVideoURL {
            viewModel.addVideo(url: videoURL)
        }
        
        viewModel.submitReviewTapped()
    }
}

/// Reusable UIViewControllerRepresentable wrapping UIImagePickerController for Photo and Video selection
struct MediaPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedVideoURL: URL?
    @Binding var selectedVideoName: String?
    var mediaTypes: [String]
    
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: MediaPicker
        
        init(_ parent: MediaPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            } else if let videoURL = info[.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
                parent.selectedVideoName = videoURL.lastPathComponent
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.mediaTypes = mediaTypes
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
//    WriteReviewView(viewModel: WriteReviewViewModel())
}
