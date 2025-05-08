//
//  onboarding 2.swift
//  curhat
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//
//

import SwiftUI


struct onboarding2: View {
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
//=================================== Image =============================================
                VStack {
                    Image("onboarding2")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea(.all)
                }
                
                VStack(spacing: 20) {
//=================================== Title =============================================
                    Spacer()
                    VStack(){
                        Text("RUANG AMAN")
                            .font(.system(.title, design: .rounded))
                            .foregroundStyle(.primary10)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("UNTUK SEMUA")
                            .font(.system(.title, design: .rounded))
                            .foregroundStyle(.primary10)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
//=================================== Body =============================================
                    VStack(alignment: .leading, spacing: 10){
                        Text("Ceritamu Aman dan Milikmu Seorang")
                            .font(.system(.title2, design: .rounded))
                            .foregroundStyle(.primary10)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Semua cerita yang telah kamu tuangkan di Emochi tidak akan dibagikan kepada siapapun, termasuk server kami. Kami tidak akan menggunakan data-datamu tanpa persetujuanmu.")
                            .font(.body)
                            .foregroundStyle(.black)
                    }
                    VStack(alignment: .leading, spacing: 10){
                        Text("Emochi Tidak Sama dengan Terapi Psikolog")
                            .font(.system(.title2, design: .rounded))
                            .foregroundStyle(.primary10)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Keberadaan Emochi tidak bisa menggantikan peran psikolog untuk membantu mengatasi masalah yang kamu hadapi. Emochi hadir sebagai garda terdepan yang akan menolong kamu untuk meluapkan emosi dalam dirimu melalui bercerita.")
                            .font(.body)
                            .foregroundStyle(.black)
                        
                    }
//===================================  Button  ==========================================
                    NavigationLink (destination: onboarding3()){
                        Text("OK!")
                            .foregroundStyle(.white)
                            .frame(maxWidth: 200)
                            .padding()
                            .background(.primary8)
                            .cornerRadius(10)
                    }
                    Spacer()
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .safeAreaPadding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
struct onboarding2_Previews: PreviewProvider {
    static var previews: some View {
        onboarding2()
    }
}

