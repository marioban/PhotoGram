import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Add your email")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
                .padding(.top)
            
            Text("You'll use this email to sign into your account")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color.secondary) // Subtle text in both themes
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            TextField("Email", text: $viewModel.email)
                .font(.subheadline)
                .modifier(IGTextFieldModifier())
            
            NavigationLink {
                CreateUsernameView()
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
    AddEmailView()
    .environmentObject(RegistrationViewModel())
}
