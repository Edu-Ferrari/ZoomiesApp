//
//
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import SwiftUI

struct HomeView: View {
    
//    let images = ["Doguin", "Jailson", "Riboli", "Leitao"]
    let image = "Doguin"
    let wearebles = ["FaixaAzul", "Tenis"]
    
    @State private var currentIndex = 0
    @State private var currentAcessory: String? = nil
    
    var body: some View {
        
        VStack{
            
            Spacer()
        
            ZStack{
                Image(image)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .overlay{
                        if let acessory = currentAcessory{
                            Image(acessory)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 450)
                        }
                            
                    }
            }
            .padding(.bottom, 80)

            Button("Trocar acessório"){
                if currentAcessory == nil{
                    currentAcessory = "FaixaAzul"
                }
                else{
                    currentAcessory = nil
                }
            }
            
            
            .padding(.bottom, 20)
            
        }
        
    }
}

#Preview {
    HomeView()
}
