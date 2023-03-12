//
//  DesignerRowView.swift
//  Designs4u
//
//  Created by Gökhan Bozkurt on 10.03.2023.
//

import SwiftUI

struct DesignerRowView: View {
    var person: Person
    var namespace: Namespace.ID
    @ObservedObject var model: DataModel
    
    @Binding var selectedDesigner: Person?
    var body: some View {
        HStack {
            Button {
                guard model.selected.count < 5 else { return }
                withAnimation(.easeInOutBack(duration: 2)) {
                    model.select(person)
                }
            } label: {
                HStack {
                    AsyncImage(url: person.thumbnail,scale: 3)
                        .frame(width: 60,height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .matchedGeometryEffect(id: person.id, in: namespace)
                    VStack(alignment: .leading) {
                        Text(person.displayName)
                            .font(.headline)
                            
                        Text(person.bio)
                            .multilineTextAlignment(.leading)
                            .font(.caption)
                    }
                }
            }
            .tint(.primary)
            Spacer()
            Button {
                selectedDesigner = person
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.borderless)

        }
    }
}

struct DesignerRowView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        DesignerRowView(person: Person.example, namespace: namespace, model: DataModel(), selectedDesigner: .constant(nil))
    }
}
