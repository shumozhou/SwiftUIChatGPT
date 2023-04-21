//import SwiftUI
//
//struct APIKeyView: View {
//
//    @State var title: String = ""
//    @State var mood: String = ""
//    @State var main: String = ""
//    @Binding var isPresented: Bool
//    @State var noChecked: Bool = true
//    @State var updateTriggered: Bool = false
//    @State private var key = ""
//    @State private var showToast: Bool = false
//    @FocusState private var fieldIsFocused: Bool
//    @State var typingMessage: String = ""
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                Text("Enter a ChatGPT Apikey")
//                    .font(.title2)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 10)
//
//                TextField("apikey",text: $typingMessage)
//                    .focused($fieldIsFocused)
//                    .foregroundColor(.white)
//                    .lineLimit(3)
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
//                    .cornerRadius(12)
//                    .padding([.leading, .trailing], 10)
//                    .shadow(color: .black, radius: 0.5)
//                    .onTapGesture {
//                        fieldIsFocused = true
//                    }
//                    .padding(.bottom, 20)
//
//                Spacer()
//                Button(action: saveKey) {
//                    Text("Save Key")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                        .padding()
//                        .frame(width: 200, height: 40)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(5.0)
//                }
//                .alert(isPresented: $showToast) {
//                    Alert(title: Text("APIKEY 为空"), message: Text("请输入APIKEY"), dismissButton: .default(Text("好")))
//                }
//                .frame(width: 200, height: 40)
////                    Button(action: {
////
////
////                    }){
////                        Text("Save")
////                            .padding(8)
////                            .frame(maxWidth: .infinity)
////                            .foregroundColor(.white)
////                            .padding(10)
////                            .overlay(RoundedRectangle(cornerRadius: 10)
////                                        .stroke(lineWidth: 2.0)
////                                        .shadow(color: .blue, radius: 10.0))
////                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
////                    }
////                    .padding(.top, 20)
//
//                    .navigationTitle("save apikey")
//                    .navigationBarTitleDisplayMode(.inline)
//                }
//            }
//    }
//}
//
//struct APIKeyView_Previews: PreviewProvider {
//    static var previews: some View {
//        APIKeyView()
//    }
//}
