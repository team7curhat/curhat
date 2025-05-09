//
//  onboarding 2.swift
//  Kalkulator Cicilan Rumah
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//
//

import SwiftUI


struct onboarding2: View {
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                // Title
                Spacer()
                VStack(spacing: 1){
                    Text("RUANG AMAN")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("UNTUK SEMUA")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 10){
                    Text("Ceritamu Aman dan Milikmu Seorang")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Semua cerita yang telah kamu tuangkan di Emochi tidak akan dibagikan kepada siapapun, termasuk server kami. Kami tidak akan menggunakan data-datamu tanpa persetujuanmu.")
                        .font(.body)
                    //                    .multilineTextAlignment()
                }
                VStack(alignment: .leading, spacing: 10){
                    Text("Emochi Tidak Sama dengan Terapi Psikolog")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Keberadaan Emochi tidak bisa menggantikan peran psikolog untuk membantu mengatasi masalah yang kamu hadapi. Emochi hadir sebagai garda terdepan yang akan menolong kamu untuk meluapkan emosi dalam dirimu melalui bercerita.")
                        .font(.body)
                }
                
                
                
                //Character
                
                // Button
                NavigationLink (destination: onboarding3().navigationBarBackButtonHidden(true)){
                    Text("OK!")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
}
struct onboarding2_Previews: PreviewProvider {
    static var previews: some View {
        onboarding2()
    }
}

