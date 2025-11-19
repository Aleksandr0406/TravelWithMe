import SwiftUI

struct StoryView: View {
    let story: Story
    
    var body: some View {
        ZStack {
            Image(uiImage: story.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text(story.title)
                        .font(.bold34)
                        .foregroundColor(.white)
                    Text(story.description)
                        .font(.regular20)
                        .lineLimit(3)
                        .foregroundColor(.white)
                }
                .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
            }
        }
    }
}
