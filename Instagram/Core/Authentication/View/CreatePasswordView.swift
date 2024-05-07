import SwiftUI

struct CreatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Create a password")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary) // Use system color that adapts to theme
                .padding(.top)
            
            Text("Password must be at least 6 characters long")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color.secondary) // Subtle text in both themes
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            SecureField("Password", text: $viewModel.password)
                .font(.subheadline)
                .modifier(IGTextFieldModifier())
        
            NavigationLink {
                CompletedSignUp()  // Ensure this view is also adapted for dark mode
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("Next")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white) // White text for contrast on button
                    .frame(width: 360, height: 44)
                    .background(Color.blue) // System color that adapts slightly between modes
                    .cornerRadius(8)
                    .padding(.top)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { // Adjusted for correct placement
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.primary) // Ensure the icon is visible in both light and dark mode
                }
            }
        }
    }
}

#Preview {
    CreatePasswordView()
    .environmentObject(RegistrationViewModel())
}
