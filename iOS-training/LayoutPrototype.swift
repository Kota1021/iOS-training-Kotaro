//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

struct LayoutPrototype: View {
    var body: some View {
            GeometryReader{ geometry in
                VStack(alignment: .center, spacing: .zero) {
                
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width/2,height: geometry.size.width/2)
                        .background(
                            Rectangle()
                                .foregroundStyle(.yellow)
                                )
                    
                    HStack{
                            Text("--")
                                .foregroundStyle(.blue)
                                .frame(width: geometry.size.width/4)
                            Text("--")
                                .foregroundStyle(.red)
                                .frame(width: geometry.size.width/4)
                    }
                    
                    Spacer().frame(height: 80)
                    
                    HStack{
                        Button("Close"){}
                            .frame(width: geometry.size.width/4)
                        Button("Reload"){}
                            .frame(width: geometry.size.width/4)
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
    }
}

#Preview {
    LayoutPrototype()
}
