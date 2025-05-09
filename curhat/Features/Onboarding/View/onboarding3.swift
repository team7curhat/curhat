import SwiftUI

struct onboarding3: View {
    
    // Replace @State with @AppStorage to persist the nickname
    @AppStorage("userNickname") private var nickname: String = ""
    
    @State private var tempNickname: String = ""
    
    @State private var goHome = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Title
                VStack(spacing: 1) {
                    Text("Ayo kita kenalan!")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, -150)
                }
                
                VStack {
                    VStack(spacing: 15) {
                        Text("Namaku Ochi!")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Kamu lebih nyaman dipanggil siapa?")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack {
                        TextField("Masukkan namamu di sini", text: $tempNickname)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: 347)
                    }
                    
                    // Character
                    
                    // Button with NavigationLink
                    
                    // Hidden NavigationLink yang listen ke `goHome`
                            NavigationLink(
                              destination: HomeView()
                                            .navigationBarBackButtonHidden(true),
                              isActive: $goHome
                            ) {
                              EmptyView()
                            }
                            .hidden()
                            
                            // Tombol OK
                            Button("OK!") {
                                
                                nickname = tempNickname
                              // baru set ke true saat ditekan
                              goHome = true
                            }
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 100)
                            .padding(10)
                            .background(tempNickname.isEmpty ? Color.gray : Color("primary-6"))
                            .cornerRadius(15)
                            .disabled(tempNickname.isEmpty)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct onboarding3_Previews: PreviewProvider {
    static var previews: some View {
        onboarding3()
    }
}
