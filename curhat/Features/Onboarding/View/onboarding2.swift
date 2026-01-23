//
//  onboarding 2.swift
//  curhat
//
//  Created by Muhammad Ferial Ishakh on 07/05/25.
//
//

import SwiftUI


struct onboarding2: View {
    
    var body: some View {
        VStack{
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
                        Text("A SAFE PLACE")
                            .font(.system(.title, design: .rounded))
                            .foregroundStyle(.primary10)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("FOR EVERYONE")
                            .font(.system(.title, design: .rounded))
                            .foregroundStyle(.primary10)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom,20)
              
                    //=================================== Body =============================================
                    VStack(alignment: .leading, spacing: 10){
                        Text("Your Stories Are Yours")
                            .font(.system(.title2, design: .rounded))
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("all the stories you have poured in Emoci will not be shared with anyone, including our servers. We will not use your data without your consent.")
                            .font(.body)
                            .foregroundStyle(.black)
                    };
                    VStack(alignment: .leading, spacing: 10)
                    {Text("Emoci is not the same as psychotherapy")
                            .font(.system(.title2, design: .rounded))
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Emoci's existence cannot replace the role of a psychologist to help overcome the problems you face. Emoci is here as a frontline that will help you to express your emotions through storytelling.")
                            .font(.body)
                            .foregroundStyle(.black)
                    }
                    //===================================  Button  ==========================================
                    NavigationLink (destination:onboarding3().navigationBarBackButtonHidden(true)){
                        Text("Understand")
                            .fontWeight(.bold)
                            .foregroundStyle(.primary7)
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.white)
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
