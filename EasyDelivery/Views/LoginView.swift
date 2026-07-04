import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @State private var name = ""
    @State private var email = ""

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isNameValid: Bool {
        !trimmedName.isEmpty
    }

    private var isEmailValid: Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private var canContinue: Bool {
        isNameValid && isEmailValid
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "shippingbox.fill")
                .font(.system(size: 60))
                .foregroundStyle(.tint)

            Text("Welcome to Easy Delivery")
                .font(.title.bold())

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)

                    if !name.isEmpty && !isNameValid {
                        Text("Name can't be blank")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    if !email.isEmpty && !isEmailValid {
                        Text("Enter a valid email address, like name@example.com")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding(.horizontal)

            Button("Continue") {
                auth.login(name: trimmedName, email: email)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!canContinue)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
