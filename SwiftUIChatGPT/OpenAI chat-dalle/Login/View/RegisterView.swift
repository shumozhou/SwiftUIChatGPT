import SwiftUI
import SPConfetti
var e: String?
struct RegisterView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmpwd: String = ""
    @State var load: Bool = false
    
    @State var alertItem: AlertItem?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1)
            VStack(alignment: .leading){
                LottieView(name: "signup", loopMode: .loop)
                    .frame(width: 250, height: 250)
                TextField("Email ID",text: $email)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 20)
                
                SecureField("Confirm Password", text: $confirmpwd)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                
                Button(action: {
                    if(password == confirmpwd){
                        self.load.toggle()
                        RealmRegister(email: email, password: password){
                            (success) -> Void in
                            if success {
                                self.load.toggle()
                                DispatchQueue.main.async {
                                    SPConfetti.startAnimating(.centerWidthToDown, particles: [.triangle, .arc], duration: 3)
                                    
                                }
                                self.alertItem = AlertItem(title: Text("Success"), message: Text("Created an account successfully! Kindly login with your credentials."), dismissButton: .default(Text("Done"), action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }))
                            } else {
                                self.load.toggle()
                                self.alertItem = AlertItem(title: Text("Error"), message: Text(e!), dismissButton: .default(Text("Done")))
                            }
                        }
                    } else {
                        self.alertItem = AlertItem(title: Text("Error"), message: Text("Passwords do not match."), dismissButton: .default(Text("Done")))
                    }
                }) {
                    if(load != true){
                        Text("Create an account")
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 0)
                                .shadow(color: .blue, radius: 10.0))
                            .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(gradient: Gradient(colors: [.black, .purple]), startPoint: .top, endPoint: .bottom)))
                    } else {
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: .gray, radius: 10.0))
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
                        .disabled(true)
                    }
                }
                .padding(.top, 10)
                .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
            }
            .alert(item: $alertItem){ item in
                Alert(title: item.title, message: item.message, dismissButton: item.dismissButton)
            }
            .navigationTitle("Register")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
        }
        .ignoresSafeArea()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
