import SwiftUI

struct CategorySidebarView: View {
    let categories: [Category]
    @Binding var selected: Category?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                CategoryRow(title: "All", isSelected: selected == nil) {
                    selected = nil
                }
                ForEach(categories) { category in
                    CategoryRow(title: category.name, isSelected: selected?.slug == category.slug) {
                        selected = category
                    }
                }
            }
        }
        .background(Color(.secondarySystemBackground))
    }
}

private struct CategoryRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        }
        .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
    }
}
