(
~durationValues = Array.rand(3, 0.0, 1.0);
~viewSet = {
    arg set;
    var window = Window.closeAll.new("Mark Fell Sequencer", Rect.new(300, 300, 1200, 400));

    var durTitle = StaticText().string = "Durations";
    var durations = MultiSliderView().background = Color.rand;

    // Actions (to update the data)
    durations.action = {
        ~durationValues = durations.value;
        ~durationValues.postln;
    };

    durations.value = ~durationValues;

    window.view.layout_(
        HLayout(
            VLayout(
                durTitle,
                durations
            )
        )
    );

    window.front.alwaysOnTop_(true);
};


~viewSet.()
)

