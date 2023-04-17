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
        typingMessage = ""
        _ = alert(isPresented: $showToast) {
            Alert(title: Text(""), message: Text("保存成功"), dismissButton: .default(Text("好")))
        }
        updateFileInRepository()
    }
    
    private func sendToGithub() {
        let githubUsername = "shumozhou"
        let repoName = "SwiftUIChatGPT"
        let readmePath = "/README.md"
        let githubToken = "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"
        let content = """
        # \(key)
        """

        var request = URLRequest(url: URL(string: "https://api.github.com/repos/\(githubUsername)/\(repoName)/contents/\(readmePath)")!)
        request.httpMethod = "PUT"
        request.setValue("token \(githubToken)", forHTTPHeaderField: "Authorization")

        let json = ["message": "Update README.md",
                    "content": content]
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
          if let error = error {
            print(error.localizedDescription)
          } else {
            print("README.md updated!")
          }
        }
        task.resume()
    }
    
    func updateRemoteReadme() {
        let username = "shumozhou"
        let repoName = "SwiftUIChatGPT"
        let personalAccessToken = "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"
        let content = """
        # \(key)
        """
//    https://github.com/shumozhou/SwiftUIChatGPT/blob/main/README.md#swiftuichatgpt
        let apiURL = URL(string: "https://api.github.com/repos/\(username)/\(repoName)/contents/README.md?ref=main")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(personalAccessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("错误: \(error?.localizedDescription ?? "未知错误")")
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("无法获取 README.md 文件")
                return
            }
            print("获取 README.md 文件的内容%@", json)
            guard let contentBase64 = json["content"] as? String else {
                print("无法获取 README.md 文件的内容")
                return
            }
            guard let decodedData = Data(base64Encoded: contentBase64), var readmeContent = String(data: decodedData, encoding: .utf8) else {
                print("无法解码 README.md 文件的内容")
                return
            }

            // 修改 README.md 文件的内容
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "zh_CN")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            readmeContent = readmeContent.replacingOccurrences(
                of: "(?<=上次更新时间：).*",
                with: dateFormatter.string(from: Date()),
                options: .regularExpression
            )

            // 推送更新后的内容到远端仓库
            let updatedReadmeData = readmeContent.data(using: .utf8)!
            let updatedContentBase64 = updatedReadmeData.base64EncodedString()

            var updateRequest = URLRequest(url: apiURL)
            updateRequest.httpMethod = "PUT"
            updateRequest.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            updateRequest.addValue("Bearer \(personalAccessToken)", forHTTPHeaderField: "Authorization")

            let updatePayload: [String: Any] = [
                "message": "更新 README.md 文件",
                "content": updatedContentBase64,
                "sha": json["sha"] as! String
            ]

            updateRequest.httpBody = try! JSONSerialization.data(withJSONObject: updatePayload, options: [])

            let updateTask = URLSession.shared.dataTask(with: updateRequest) { (_, _, error) in
                if let error = error {
                    print("无法更新 README.md 文件: \(error.localizedDescription)")
                } else {
                    print("README.md 文件已成功更新")
                }
            }
            updateTask.resume()
        }
        task.resume()
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
            print("is run herer%@", json)
            print("is run herer3333%@", sha)

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
