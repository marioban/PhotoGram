import SwiftUI

struct CurrentUserProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    private var profileComposite: ProfileComposite
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
        
        profileComposite = ProfileComposite()
        profileComposite.add(component: ProfileHeaderView(user: user))
        profileComposite.add(component: PostGridView(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                profileComposite.render()
            }
            .refreshable {
                await viewModel.refreshProfile()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    signOutButton
                }
            }
        }
    }
    
    private var signOutButton: some View {
        Button {
            AuthService.shared.signout()
            AuthService.shared.googleSignOut()
            AuthService.shared.githubSignOut()
        } label: {
            Image(systemName: "door.left.hand.open")
                .foregroundColor(Color.primary)
        }
    }
}
