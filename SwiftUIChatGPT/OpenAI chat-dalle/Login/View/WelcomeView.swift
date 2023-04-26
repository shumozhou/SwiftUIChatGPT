import SwiftUI
import RealmSwift

struct WelcomeView: View {
    
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var country: String = ""
    @State private var gender: String = ""
    @State var navigated: Bool = false
    let realm = try! Realm()
    var body: some View {
        ZStack {
            Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1)
            VStack(alignment: .leading){
                Text("We need to get to know you a little better.")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                TextField("Name",text: $name)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 20)
                
                TextField("Age",text: $age)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 20)
                
                TextField("Gender",text: $gender)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 20)
                
                TextField("Country",text: $country)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5.0)
                        .stroke(lineWidth: 1.0))
                    .padding(.bottom, 20)
                NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true), isActive: $navigated) {
                    Button(action: {
                        let user = RealmUser()
                        user.userID = uid
                        user.gender = gender
                        user.name = name
                        user.age = age
                        user.country = country
                        
                        try! realm.write{
                            realm.add(user)
                            self.navigated.toggle()
                        }
                    }) {
                        if(navigated == true){
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
                        } else {
                            Text("Continue")
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2.0)
                                    .shadow(color: .blue, radius: 10.0))
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        }
                    }
                }
            }
            .navigationTitle("Welcome!")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
        }
        .ignoresSafeArea()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
