import SwiftUI
import Combine

struct StoriesView: View {
    let viewModel: StoriesViewModel
    
    var body: some View {
        TabView(selection: viewModel.$stateProperty.tabSelection) {
            FullStoryConstructorView(fullStoryIndex: 0, viewModel: viewModel)
                .tag(0)
            FullStoryConstructorView(fullStoryIndex: 1, viewModel: viewModel)
                .tag(1)
            FullStoryConstructorView(fullStoryIndex: 2, viewModel: viewModel)
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

private struct FullStoryConstructorView: View {
    struct Configuration {
        let timerTickInternal: TimeInterval
        let progressPerTick: CGFloat
        
        init(
            storiesCount: Int,
            secondsPerStory: TimeInterval = 5,
            timerTickInternal: TimeInterval = 0.25
        ) {
            self.timerTickInternal = timerTickInternal
            self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInternal
        }
    }
    
    let viewModel: StoriesViewModel
    
    @State private var indexCalc = 0
    @State var progress: CGFloat = 0
    @State var cancellable: Cancellable?
    @State var timer: Timer.TimerPublisher
    
    private var stories: [FullStory] = [.fullStory1, .fullStory2, .fullStory3]
    private let configuration: Configuration
    private var fullStoryIndex: Int
    private var currentStory: Story { stories[fullStoryIndex].stories[currentStoryIndex] }
    private var currentStoryIndex: Int { Int(progress * CGFloat(stories[fullStoryIndex].stories.count)) }
    
    init(
        fullStoryIndex: Int,
        viewModel: StoriesViewModel
    ) {
        self.fullStoryIndex = fullStoryIndex
        configuration = Configuration(storiesCount: stories[fullStoryIndex].stories.count)
        timer = Self.createTimer(configuration: configuration)
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoryView(story: currentStory)
            ProgressBar(numberOfSections: stories[fullStoryIndex].stories.count, progress: progress)
                .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
            HStack(alignment: .center, spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        previousStory()
                        resetTimer()
                    }
                Rectangle()
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        nextStory()
                        resetTimer()
                    }
            }
            CloseButton(action: { viewModel.stateProperty.isPresentingStory = false })
                .padding(.top, 57)
                .padding(.trailing, 12)
        }
        .onAppear {
            timer = Self.createTimer(configuration: configuration)
            cancellable = timer.connect()
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .onReceive(timer) { _ in
            timerTick()
        }
    }
    
    private func checkLastStory() {
        let storiesCount = stories[fullStoryIndex].stories.count
        let currentStoryIndex = Int(progress * CGFloat(storiesCount))
        
        if currentStoryIndex + 1 < storiesCount {
            let nextStoryIndex = currentStoryIndex + 1
            withAnimation {
                progress = CGFloat(nextStoryIndex) / CGFloat(storiesCount)
            }
        } else if viewModel.stateProperty.indexOfGroupStories < stories.count - 1 {
            viewModel.stateProperty.tabSelection = viewModel.stateProperty.indexOfGroupStories + 1
            viewModel.stateProperty.indexOfGroupStories += 1
        } else {
            viewModel.stateProperty.isPresentingStory = false
        }
    }
    
    private func timerTick() {
        var nextProgress = progress + configuration.progressPerTick
        
        if nextProgress >= 1 {
            nextProgress = 0
            nextStory()
        }
        withAnimation {
            progress = nextProgress
        }
    }
    
    private func nextStory() {
        let storiesCount = stories[fullStoryIndex].stories.count
        let currentStoryIndex = Int(progress * CGFloat(storiesCount))
        
        if currentStoryIndex + 1 < storiesCount {
            let nextStoryIndex = currentStoryIndex + 1
            withAnimation {
                progress = CGFloat(nextStoryIndex) / CGFloat(storiesCount)
            }
        } else if viewModel.stateProperty.indexOfGroupStories < stories.count - 1 {
            viewModel.stateProperty.tabSelection = viewModel.stateProperty.indexOfGroupStories + 1
            viewModel.stateProperty.indexOfGroupStories += 1
        } else {
            viewModel.stateProperty.isPresentingStory = false
        }
    }
    
    private func previousStory() {
        let storiesCount = stories.count
        let currentStoryIndex = Int(progress * CGFloat(storiesCount))
        let previousStoryIndex = currentStoryIndex - 1 > 0 ? currentStoryIndex - 1 : 0
        withAnimation {
            progress = CGFloat(previousStoryIndex) / CGFloat(storiesCount)
        }
        
        if currentStoryIndex - 1 >= 0 {
            let previousStoryIndex = currentStoryIndex - 1
            withAnimation {
                progress = CGFloat(previousStoryIndex) / CGFloat(storiesCount)
            }
        } else if viewModel.stateProperty.indexOfGroupStories > 0 {
            viewModel.stateProperty.tabSelection = viewModel.stateProperty.indexOfGroupStories - 1
            viewModel.stateProperty.indexOfGroupStories -= 1
        } else {
            viewModel.stateProperty.isPresentingStory = false
        }
    }
    
    private func resetTimer() {
        cancellable?.cancel()
        timer = Self.createTimer(configuration: configuration)
        cancellable = timer.connect()
    }
    
    private static func createTimer(configuration: Configuration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }
}
