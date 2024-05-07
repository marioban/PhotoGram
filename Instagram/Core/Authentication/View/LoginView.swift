//
//  LoginView.swift
//  Instagram
//
//  Created by Mario Ban on 08.12.2023..
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                Spacer()
                
                Image("Instagram_logo")  // Ensure you have a version of this logo that looks good on both light and dark backgrounds
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .modifier(IGTextFieldModifier())
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(IGTextFieldModifier())
                }
                
                Button {
                    print("Show forgot password")
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color.primary)  // Adapts to light or dark mode
                
                Button {
                    Task { try await viewModel.signIn() }
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)  // White text for buttons is usually safe for readability
                        .frame(width: 360, height: 44)
                        .background(Color.blue)  // System blue adapts slightly between modes
                        .cornerRadius(8)
                }
                .padding(.vertical)
                
                HStack {
                    VStack {
                        Divider()
                    }
                    Text("OR")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)  // Adapts to light or dark mode but is static in color
                    VStack {
                        Divider()
                    }
                }
                .padding(.horizontal, 24)
                
                socialLoginButton(imageName: "facebook-logo", buttonText: "Login with Facebook")
                socialLoginButton(imageName: "google-logo", buttonText: "Login with Google", topPadding: 10)
                
                Spacer()
                Divider()
                NavigationLink {
                    AddEmailView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
        }
    }
    
    @ViewBuilder
    private func socialLoginButton(imageName: String, buttonText: String, topPadding: CGFloat = 0) -> some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Button {
                print("\(buttonText)")
            } label: {
                Text(buttonText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding(.top, topPadding)
        .foregroundColor(Color.primary)  // Ensures text adapts to light/dark mode
    }
}

#Preview {
    LoginView()
}
