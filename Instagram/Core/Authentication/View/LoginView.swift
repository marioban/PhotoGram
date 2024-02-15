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
                
                Image("Instagram_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 100)
                
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
                
                Button {
                    Task { try await viewModel.signIn()}
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                        .frame(width: 360,height: 44)
                        .background(Color(.systemBlue))
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
                        .foregroundStyle(Color.gray)
                    VStack {
                        Divider()
                    }
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                
                
                HStack {
                    Image("facebook-logo")
                        .resizable()
                        .frame(width: 30,height: 30)
                    
                    Button {
                        print("Facebook login")
                    } label: {
                        Text("Login with Facebook")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                
                HStack {
                    Image("google-logo")
                        .resizable()
                        .frame(width: 30,height: 30)
                    
                    Button {
                        print("Google login")
                    } label: {
                        Text("Login with Google")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.top, 10)
                
                
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
}

#Preview {
    LoginView()
}
