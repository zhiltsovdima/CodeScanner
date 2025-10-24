//
//  QrCodeDetailView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct QrCodeDetailView: View {
    let content: QRCodeContent
    
    @State private var showingSafari = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: content.isURL ? "link" : "qrcode")
                        .font(.system(size: 60))
                        .foregroundStyle(content.isURL ? .blue : .secondary)
                    
                    Text(content.isURL ? "Link detected" : "Text content")
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                }
                .padding(.top)
                
                contentCard
                
                actionButtons
            }
            .padding()
        }
        .navigationTitle("QR Code")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingSafari) {
            if let url = content.url {
                SafariView(url: url)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [content.displayText])
        }
    }
    
    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack {
                Text(content.displayText)
                    .font(.body.monospaced())
                    .foregroundStyle(.primary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button {
                    UIPasteboard.general.string = content.displayText
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.title3)
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if content.isURL {
                Button {
                    showingSafari = true
                } label: {
                    Label("Open in Safari", systemImage: "safari")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
    }
}
