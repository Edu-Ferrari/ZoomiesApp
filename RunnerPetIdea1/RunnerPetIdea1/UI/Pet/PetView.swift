//
//  PetView.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//


import SwiftUI
import SpriteKit
import SwiftData

struct PetView: View {
    @Environment(\.modelContext) private var ctx
    @Query private var profiles: [UserProfile]
    @State private var scene = PetScene(size: CGSize(width: 320, height: 320))
    @State private var shareImage: UIImage?
    @State private var showingShare = false

    private var currentPetBg: String {
        let repo = MapRepository()
        let id = profiles.first?.currentMapId ?? "world1"
        return (repo.byId(id)?.petBackgroundAsset) ?? "pet/bg_world1"
    }

    var body: some View {
        ZStack {
            Image(currentPetBg).resizable().scaledToFill().ignoresSafeArea()
            VStack(spacing: 16) {
                SpriteView(scene: scene).frame(width: 320, height: 320)
                HStack {
                    Button { makeShareImage() } label: { Label("Compartilhar", systemImage: "square.and.arrow.up") }
                    Button { /* Loja futura */ } label: { Label("Loja", systemImage: "cart") }
                }
            }
        }
        .sheet(isPresented: $showingShare) {
            if let img = shareImage { ShareCardView(image: img) }
        }
    }

    private func makeShareImage() {
        guard let skView = scene.view else { return }
        // Dummy stats for now
        let stats = ShareStats(km: 12.4, paceText: "5:10/km", rankText: "#3 no grupo")
        let id = profiles.first?.currentMapId ?? "world1"
        let bg = MapRepository().byId(id).map { UIImage(named: $0.backgroundAsset) } ?? nil
        self.shareImage = ShareRenderer.render(from: skView, stats: stats, mapBackground: bg ?? nil)
        self.showingShare = true
    }
}
