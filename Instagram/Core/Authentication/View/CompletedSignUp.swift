import SwiftUI

struct CompletedSignUp: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text("Welcome to Instagram, \(viewModel.username)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            Text("Click below to complete registration and start using Instagram")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button {
                Task { try await viewModel.createUser()}
            } label: {
                Text("Complete registration")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360, height: 44)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.top)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.primary) 
                }
            }
        }
    }
}

#Preview {
    CompletedSignUp()
    .environmentObject(RegistrationViewModel())
}
