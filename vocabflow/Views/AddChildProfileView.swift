//
//  AddChildProfileView.swift
//  vocabflow
//
//  Created by Kevin Sofyan on 19/01/26.
//

import SwiftUI

struct AddChildProfileView: View {
    @State private var childName: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var showDatePicker: Bool = false
    @State private var selectedGradeLevel: String = ""
    @State private var showDashboard: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false

    private let gradeLevels = [
        "Kindergarten",
        "1st Grade",
        "2nd Grade",
        "3rd Grade",
        "4th Grade",
        "5th Grade",
        "6th Grade",
        "7th Grade",
        "8th Grade"
    ]

    var body: some View {
        if showDashboard {
            DashboardView()
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Profile Photo
                    VStack(spacing: 12) {
                        Button(action: { showImagePicker = true }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.accentPurple.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.primary)
                                        Text("Upload Photo")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    
                    // Child's Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Child's Name")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        TextField("Enter child's name", text: $childName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    // Date of Birth
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date of Birth")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Button(action: { showDatePicker.toggle() }) {
                            HStack {
                                Text(dateOfBirth == Date() ? "Enter child's birthdate" : dateOfBirth.formatted(date: .long, time: .omitted))
                                    .foregroundColor(dateOfBirth == Date() ? .gray : .primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }

                        if showDatePicker {
                            DatePicker(
                                "Select date",
                                selection: $dateOfBirth,
                                in: ...Date(),
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }

                    // Grade Level
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Grade Level")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Menu {
                            ForEach(gradeLevels, id: \.self) { grade in
                                Button(grade) {
                                    selectedGradeLevel = grade
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedGradeLevel.isEmpty ? "Select grade level" : selectedGradeLevel)
                                    .foregroundColor(selectedGradeLevel.isEmpty ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }

                    // Create Profile Button
                    Button(action: {
                        showDashboard = true
                    }) {
                        Text("Create Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentPurple)
                            .cornerRadius(28)
                    }
                    .padding(.top, 8)

                    // Add another child section
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock")
                                .foregroundColor(.gray.opacity(0.5))
                            Text("+ Add another child")
                                .foregroundColor(.gray)
                        }

                        Text("Upgrade plan to add more child profiles.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Assume up to 3 child profiles for demonstration.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(16)
                    .padding(.top, 16)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
            .navigationTitle("Add Child Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        AddChildProfileView()
    }
}
