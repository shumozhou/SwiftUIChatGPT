import SwiftUI
import RealmSwift

struct UserPage: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    @ObservedObject private var dataStore = DataStore.shared
    @State var apiKey: String = ""
    @State var presented: Bool = false
    private var user: RealmUser? {
        dataStore.user
    }
    
    @State
    private var isOpen: Bool = false
    
    @State
    private var isToggled: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if let name = user?.name {
                    Text("name: " + name)
                        .font(.title)
                        .padding(.top, 5)
                }
                if let age = user?.age {
                    Text("age: " + age)
                        .font(.title)
                        .padding(.top, 5)
                }
                if let country = user?.country {
                    Text("country: " + country)
                        .font(.title)
                        .padding(.top, 5)
                }
                
                HStack {
                    Text("Key: " + apiKey)
                        .font(.title)
                        .padding([.top], 10)
                    Spacer()
                    Button(action: {
                        self.presented.toggle()
                    }) {
                        Image(systemName: "pencil.circle.fill")
                    }
                    .sheet(isPresented: $presented){
                        MineView(isPresented: $presented)
                    }
                }
//                Text("Total Pages written: \(dataStore.diaries?.count ?? 0)")
//                    .font(.title3)
//                    .padding(.top, 10)
                
                HStack {
                    Text("Your Public Diaries")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        self.isOpen.toggle()
                    }) {
                        Image(systemName: buttonValue)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 20)
                if(isOpen == true) {
                    if let publicDiaries = dataStore.publicDiaries {
                        ScrollView{
                            ForEach(publicDiaries){ data in
                                //                                ListView(
                                //                                    date: data.date,
                                //                                    title: data.title,
                                //                                    mood: data.mood,
                                //                                    value: data.value,
                                //                                    functionEnabled: false
                                //                                )
                            }
                        }
                    }
                }
                Spacer()
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $isToggled) {
                    Button(action: {
                        app.currentUser?.logOut { (error) in
                            if let e = error {
                                print(e.localizedDescription)
                            } else {
                                DispatchQueue.main.async {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                print("logged out")
                                self.isToggled.toggle()
                            }
                        }
                    }) {
                        Text("Logout")
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
            .padding()
            .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
            .navigationTitle("Hello \(dataStore.user?.name ?? "")")
        }
        .onAppear{
            apiKey = UserDefaults.standard.string(forKey: "APIKEY") ?? ""
            print("ContentView appeared" + apiKey)
        }
        .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
        .navigationBarHidden(true)
        .navigationTitle("")
    }
    
    var buttonValue: String {
        return isOpen ? "chevron.up.circle.fill" : "chevron.down.circle.fill"
    }
}

struct UserPage_Previews: PreviewProvider {
    static var previews: some View {
        UserPage()
    }
}
