//
//  UserRowView.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation
import SwiftUI

struct UserRowView: View {
    @StateObject var viewModel: UserRowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isLiked ? .red : .gray)
                    .imageScale(.large).onTapGesture {
                        viewModel.toggleLike()
                    }
            }
            
            Text("@\(viewModel.username)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Divider()
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.blue)
                Text(viewModel.email)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            HStack {
                Image(systemName: "building.2")
                    .foregroundColor(.orange)
                Text(viewModel.companyName)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.green)
                Text(viewModel.cityName)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
    }
}
