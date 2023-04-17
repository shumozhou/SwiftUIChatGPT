import SwiftUI

struct MineView: View {
    @State private var key = ""
    @State private var showToast: Bool = false
    @FocusState private var fieldIsFocused: Bool
    @State var typingMessage: String = ""
    var body: some View {
        NavigationView(){
            VStack {
                HStack(alignment: .center) {
                    Text("Key:")
                        .padding([.leading], 10)
                    Spacer()
                    TextField("APIkey...", text: $typingMessage, axis: .vertical)
                        .focused($fieldIsFocused)
                        .padding()
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
                        .cornerRadius(12)
                        .padding([.leading, .trailing], 10)
                        .shadow(color: .black, radius: 0.5)
                        .onTapGesture {
                            fieldIsFocused = true
                        }
                }
                
                Spacer()
                
                Button(action: saveKey) {
                    Text("Save Key")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(width: 200, height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .alert(isPresented: $showToast) {
                    Alert(title: Text("APIKEY 为空"), message: Text("请输入APIKEY"), dismissButton: .default(Text("好")))
                }
                .frame(width: 200, height: 40)
            }
            .onAppear {
                //                loadKey()
            }
            .onDisappear {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
            .background(Color(red: 53/255, green: 54/255, blue: 65/255))
            .gesture(TapGesture().onEnded {
                hideKeyboard()
            })
            .navigationTitle("tadie")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveKey() {
        print("iiiiiiii" + typingMessage)
        if typingMessage.isEmpty {
            showToast = true
            return
        }
        
        print("iiiiiiii33333" + typingMessage)
        hideKeyboard()
        key = typingMessage
        UserDefaults.standard.set(key, forKey: "APIKEY")
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
