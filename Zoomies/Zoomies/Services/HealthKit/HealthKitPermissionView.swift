//
//  HealthKitPermissionView.swift
//  Zoomies
//
//  Created by Eduardo Ferrari on 11/09/25.
//

import SwiftUI

struct HealthPermissionView: View {
    @ObservedObject var hk: HealthKitManager
    @State private var showHowTo = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 56, weight: .semibold))
            Text("Permissão necessária").font(.title2.bold())

            Group {
                if hk.authState == .unknown {
                    Text("Para usar esta funcionalidade, permita o acesso aos seus passos no app Saúde.")
                } else {
                    Text("Você negou o acesso aos Passos. Para ativar novamente, siga as instruções.")
                }
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)

            if let err = hk.authorizationError, !err.isEmpty {
                Text(err)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if hk.authState == .unknown {
                Button("Permitir agora") { hk.requestAuthorization() }
                    .buttonStyle(.borderedProminent)
            }

            Button("Abrir Ajustes") { showHowTo = true }
                .buttonStyle(.bordered)
        }
        .padding(24)
        .sheet(isPresented: $showHowTo) {
            SettingsHowToSheet(
                appName: Bundle.main.appDisplayName,
                onOpenSettings: { hk.openSettings() }
            )
            .presentationDetents([.medium, .large])
        }
        .onChange(of: hk.authState) { oldState, newState in
            if newState == .authorized {
                showHowTo = false
            }
        }
    }
}

extension Bundle {
    var appDisplayName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        ?? object(forInfoDictionaryKey: "CFBundleName") as? String
        ?? "Este app"
    }
}

