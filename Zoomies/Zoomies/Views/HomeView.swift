//
//
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import SwiftUI

struct HomeView: View {
    
    let image = "Doguin"
    let wearebles = ["FaixaAzul", "Tenis"]
    
    @State private var currentIndex = 0
    @State private var currentAcessory: String? = nil
    
    
    @State private var showInventoryModal: Bool = false
    @State private var showEmblemModal: Bool = false
    
    var body: some View {
        
        VStack{
            
            //HStack que lida com as moedas e os rubis
            HStack(alignment: .center, spacing: 60){
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 150, height: 50)
                        .foregroundStyle(.gray)
                    
                    
                    HStack{
                        Image("SapoMoedas")
                            .resizable()
                            .frame(width: 54, height: 54)
                        
                        Spacer()
                        
                        Text("1.1K")
                            .font(.title3)
                    }
                    .padding(.horizontal, 12)
                    .frame(width: 150, height: 50)
                    
                    
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 150, height: 50)
                        .foregroundStyle(.gray)
                    
                    HStack{
                        Image("Rubi")
                            .resizable()
                            .frame(width: 54, height: 54)
                        
                        Spacer()
                        
                        Text("390")
                            .font(.title3)
                    }
                    .padding(.horizontal, 12)
                    .frame(width: 150, height: 50)
                }
            }
            
            HStack(alignment: .top){
                
                VStack{
                    
                    
                    Button{
                        showEmblemModal.toggle()
                    }label: {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 56, weight: .bold, design: .default))
                            .foregroundStyle(.gray)
                            .padding(.top, 55)
                    }
                    .sheet(isPresented: $showEmblemModal){
                        EmblemsModal()
                    }
                    
                    
                    
                    Text("Emblemas")
                }
                
                Spacer()
                
                VStack{
                    ZStack{
                        Button{
                            showInventoryModal.toggle()
                        }label: {
                            Image("Mochila")
                                .frame(width: 86)
                        }
                        .sheet(isPresented: $showInventoryModal){
                            InventoryModal()
                        }
                    }
                    
                    Text("Inventário")
                        .padding(.top, -50)
                }
            }
            .padding(.horizontal, 16)

            
            Spacer()
        
            
            
            
            
            
            
            //Stack do personagem
            VStack{
                
                Text("Txutxucão")
                    .padding(.bottom, 20)
                
                
                
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
