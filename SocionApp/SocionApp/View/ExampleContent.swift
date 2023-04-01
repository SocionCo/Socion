//
//  ExampleContent.swift
//  SocionApp
//
//  Created by Daniel Biundo on 4/1/23.
//

import SwiftUI

struct ExampleContent: View {
    @EnvironmentObject var authentication : Authentication
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).onTapGesture {
            authentication.updateValidation(success: false)
        }
    }
}

struct ExampleContent_Previews: PreviewProvider {
    static var previews: some View {
        ExampleContent()
    }
}
