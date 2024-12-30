//
//  ChartContainer.swift
//  StepTracker
//
//  Created by Ali Görkem Aksöz on 28.12.2024.
//

import SwiftUI

struct ChartContainerConfiguration {
    let title: String
    let symbol: String
    let subtitle: String
    let context: HealtMetricContext
    let isNav: Bool
}

struct ChartContainer<Content: View>: View {
        
    let config: ChartContainerConfiguration
    
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading) {
            if config.isNav {
                navigationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

extension ChartContainer {
    var navigationLinkView: some View {
        NavigationLink(value: config.context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(config.title, systemImage: config.symbol)
                .font(.title3).bold()
                .foregroundStyle(config.context == .steps ? .pink : .indigo)
            
            Text(config.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ChartContainer(config: .init(title: "Test Title", symbol: "figure.walk", subtitle: "Test Subtitle", context: .steps, isNav: true)){
        Text("Chart Goes Here")
            .frame(minWidth: 150, minHeight: 150)
    }
}
