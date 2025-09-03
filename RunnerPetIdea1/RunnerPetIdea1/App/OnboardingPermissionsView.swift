//
//  OnboardingPermissionsView.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//


import SwiftUI

struct OnboardingPermissionsView: View {
    @EnvironmentObject var app: AppState
    @AppStorage("hk_permission_asked") private var hkAsked = false
    @State private var loading = false
    @State private var errorText: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Permitir Saúde").font(.title2.bold())
            Text("Usamos seus passos e distância (caminhada/corrida) para calcular progresso e missões. Nada de carro/bicicleta.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button {
                Task { await requestHK() }
            } label: { Label("Permitir Health", systemImage: "heart.fill") }
            .buttonStyle(.borderedProminent)
            .disabled(loading)

            if loading { ProgressView() }
            if let e = errorText { Text(e).foregroundStyle(.red) }
        }
        .padding()
    }

    private func requestHK() async {
        guard !hkAsked else { return }
        loading = true
        do {
            try await app.health.requestAuthorization()
            app.health.startObservers()
            hkAsked = true
        } catch {
            errorText = "Não foi possível obter permissão do Health."
        }
        loading = false
    }
}
