//
//  ShareCardView.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//


//
//import SwiftUI
//import SpriteKit
//
//struct ShareStats { let km: Double; let paceText: String; let rankText: String }
//
//enum ShareRenderer {
//    static func render(from skView: SKView, stats: ShareStats, mapBackground: UIImage?) -> UIImage {
//        let baseSize = CGSize(width: 1080, height: 1350)
//        let renderer = UIGraphicsImageRenderer(size: baseSize)
//        return renderer.image { ctx in
//            if let bg = mapBackground {
//                bg.draw(in: CGRect(origin: .zero, size: baseSize))
//            } else {
//                UIColor.systemBackground.setFill()
//                ctx.fill(CGRect(origin: .zero, size: baseSize))
//            }
//            if let scene = skView.scene, let tex = skView.texture(from: scene) {
//                let ui = UIImage(cgImage: tex.cgImage())
//                ui.draw(in: CGRect(x: 180, y: 180, width: 720, height: 720))
//            }
//            let paragraph = NSMutableParagraphStyle(); paragraph.alignment = .center
//            let titleAttrs: [NSAttributedString.Key: Any] = [
//                .font: UIFont.boldSystemFont(ofSize: 52), .foregroundColor: UIColor.label,
//                .paragraphStyle: paragraph
//            ]
//            let bodyAttrs: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 42, weight: .medium), .foregroundColor: UIColor.secondaryLabel,
//                .paragraphStyle: paragraph
//            ]
//            ("RunnerPet • Progresso").draw(in: CGRect(x: 90, y: 60, width: 900, height: 80), withAttributes: titleAttrs)
//            ("Km: \(Int(stats.km))  •  Pace: \(stats.paceText)  •  \(stats.rankText)")
//                .draw(in: CGRect(x: 60, y: 950, width: 960, height: 140), withAttributes: bodyAttrs)
//        }
//    }
//}
//
//struct ShareCardView: View {
//    let image: UIImage
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Image(uiImage: image).resizable().scaledToFit()
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//                .shadow(radius: 8)
//            ShareLink(item: Image(uiImage: image),
//                      preview: SharePreview("Meu progresso no RunnerPet",
//                                            image: Image(uiImage: image))) {
//                Label("Compartilhar", systemImage: "square.and.arrow.up").font(.headline)
//            }
//        }.padding()
//    }
//}
