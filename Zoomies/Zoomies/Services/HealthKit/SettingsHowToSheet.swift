//
//  SettingHowToSheet.swift
//  Zoomies
//
//  Created by Eduardo Ferrari on 11/09/25.
//

import SwiftUI

struct SettingsHowToSheet: View {
    let appName: String
    let onOpenSettings: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Label("Como permitir novamente", systemImage: "hand.tap")
                    .font(.title3.bold())

                VStack(alignment: .leading, spacing: 12) {
                    HowToRow(symbol: "gear", text: "Abra **Ajustes**")
                    HowToRow(symbol: "lock.shield", text: "Entre em **Privacidade e Segurança**")
                    HowToRow(symbol: "heart", text: "Toque em **Saúde**")
                    HowToRow(symbol: "app", text: "Toque em **Apps** ")
                    HowToRow(symbol: "app.badge.checkmark", text: "Selecione **\(appName)**")
                    HowToRow(symbol: "checkmark.circle", text: "Ative **todas** as permissões necessárias (ex.: *Passos*)")
                }

                Spacer(minLength: 8)


                Text("Dica: após abrir os Ajustes do app, use a barra de busca dos Ajustes e digite **Saúde** para chegar mais rápido em Privacidade → Saúde.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding()
            .navigationTitle("Permissões")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct HowToRow: View {
    let symbol: String
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbol).frame(width: 22)
            Text(.init(text)) // permite **negrito** com markdown
        }
    }
}
