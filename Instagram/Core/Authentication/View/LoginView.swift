//
//  LoginView.swift
//  Instagram
//
//  Created by Mario Ban on 08.12.2023..
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var viewModel = LoginViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                Spacer()
                
                Image("Instagram_logo")  
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
                .foregroundColor(Color.primary)
                
                Button {
                    Task { try await viewModel.signIn() }
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 44)
                        .background(Color.blue)
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
                        .foregroundColor(Color.gray)
                    VStack {
                        Divider()
                    }
                }
                .padding(.horizontal, 24)
                
                socialLoginButton(imageType: .asset(name: "google-logo"), buttonText: "Login with Google", topPadding: 10)
                socialLoginButton(imageType: .asset(name: "github-logo"), buttonText: "Login with GitHub", topPadding: 10)
                socialLoginButton(imageType: .system(name: "theatermasks.circle"), buttonText: "Go Anonymus", topPadding: 10)
                    .onTapGesture {
                        authService.enterAnonymousMode()
                    }

                
                Spacer()
                Divider()
                NavigationLink {
                    AddEmailView()
                        .environmentObject(registrationViewModel)
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
    private func socialLoginButton(imageType: ImageType, buttonText: String, topPadding: CGFloat = 0) -> some View {
        HStack {
            Group {
                switch imageType {
                case .system(let name):
                    Image(systemName: name)
                    .resizable()
                case .asset(let name):
                    Image(name)
                    .resizable()
                }
            }
            .scaledToFit()
            .frame(width: 30, height: 30)
            .background(
                Circle()
                    .fill(Color.white)
                    .frame(width: 30, height: 30)
            )
            .clipShape(Circle())
            
            Button {
                print("\(buttonText)")
            } label: {
                Text(buttonText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding(.top, topPadding)
        .foregroundColor(Color.primary)
    }
}

#Preview {
    LoginView()
}
