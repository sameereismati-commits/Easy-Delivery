import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @State private var name = ""
    @State private var email = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "shippingbox.fill")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("Welcome to Easy Delivery")
                .font(.title.bold())

            VStack(spacing: 12) {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            .padding(.horizontal)

            Button("Continue") {
                auth.login(name: name, email: email)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(name.isEmpty || email.isEmpty)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
